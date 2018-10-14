# Brian Aly - brian.aly@mail.utoronto.ca 

import sys
import os
import settings
import networks
import numpy as np
import tensorflow as tf
from abc import ABC, abstractmethod


class Policy(ABC):
    """
    """
    def __init__(self):
        super().__init__()

    @abstractmethod
    def build_graph(self):
        raise NotImplementedError

    @abstractmethod
    def choose_action(self, state):
        raise NotImplementedError


class PPO(Policy):
    """
    """
    def __init__(self):
        super().__init__()
        self.actor = None 
        self.old_actor = None 
        self.critic = None 


        # old stuff 
        self.session = tf.Session(config=tf.ConfigProto(allow_soft_placement=True,log_device_placement=False))
        self.actor = networks.Actor_MLP(scope="actor1",units=[settings.S_DIM,100,settings.A_DIM],activations=[None,'relu','tanh'],trainable=True)
        self.old_actor = networks.Actor_MLP(scope="actor0",units=[settings.S_DIM,100,settings.A_DIM],activations=[None,'relu','tanh'],trainable=False)
        self.critic =  networks.Critic_MLP(scope="critic1",units=[settings.S_DIM,100,1],activations=[None,'relu',None],trainable=True)

        self.state_tf = tf.placeholder(dtype=tf.float32,shape=[None,settings.S_DIM])
        self.action_tf = tf.placeholder(dtype=tf.float32,shape=[None,settings.A_DIM])
        self.return_tf = tf.placeholder(dtype=tf.float32,shape=[None,1]) 
        self.adv_tf = tf.placeholder(dtype=tf.float32,shape=[None,1]) 
        
        # global steps to keep track of training
        self.actor_step = tf.get_variable('actor_global_step', [], initializer=tf.constant_initializer(0), trainable=False)
        self.critic_step = tf.get_variable('critic_global_step', [], initializer=tf.constant_initializer(0), trainable=False)

        # build computation graphs
        self.actor.build_graph(self.state_tf,self.actor_step) 
        self.old_actor.build_graph(self.state_tf,0)
        self.critic.build_graph(self.state_tf,self.critic_step)
        self.build_graph()


    def build_graph(self):
        '''
        Builds the tensorflow computation graph for the agent loss operations
        Inputs:
            states: numpy array of state observations
        '''

        # critic training nodes
        self.advantage_diff = self.return_tf - self.critic.outputs[-1] # differentiable 
        with tf.variable_scope('critic'):
            self.critic_loss = tf.reduce_mean(tf.square(self.advantage_diff))
            self.critic_train_op = tf.train.AdamOptimizer(settings.C_LR).minimize(self.critic_loss,global_step=self.critic_step)

        # actor training nodes
        current_policy = self.actor.norm_dist
        current_parameters = self.actor.params

        old_policy = self.old_actor.norm_dist
        old_parameters = self.old_actor.params

        with tf.variable_scope('sample_action'):
            self.sample_op = tf.squeeze(current_policy.sample(1),axis=0)
        with tf.variable_scope('update_oldpi'): 
            self.update_old_actor_op = [oldparams.assign(params) for params,oldparams in zip(current_parameters,old_parameters)]
       
        with tf.variable_scope('loss'):
            prob_ratio = current_policy.prob(self.action_tf) / old_policy.prob(self.action_tf)
            surr = tf.multiply(prob_ratio, self.adv_tf)
            self.actor_loss = -1.0 * tf.reduce_mean(tf.minimum(
                                 surr,
                                 tf.clip_by_value(prob_ratio,1.-settings.CLIP,1.+settings.CLIP)*self.adv_tf))
       
        with tf.variable_scope('atrain'):
            self.actor_train_op = tf.train.AdamOptimizer(settings.A_LR).minimize(self.actor_loss,global_step=self.actor_step)

        self.initializer = tf.global_variables_initializer()

        self.saver = tf.train.Saver(tf.global_variables())

        self.session.run(self.initializer)

    def get_v(self,state):
        '''
        Queries the critic network to approximate a value for the given state
        Inputs:
            states: numpy array of state observations
        Outputs:
            value:
        '''
        state = np.expand_dims(state,axis=0)
        value = self.session.run(self.critic.outputs[-1], {self.state_tf:state})[0,0]
        return value

    def choose_action(self, state):
        '''
        Queries the actor network to sample an action from a gaussian distribution
        that is obtained from the output of the nerual network at the given state
        Inputs:
            states: numpy array of state observations
        Outputs:
            action: sampled from a gaussian with mean and variance predicted by the actor NN
        '''
        state = np.expand_dims(state,axis=0)
        action = self.session.run(self.sample_op, {self.state_tf:state})[0]
        return np.clip(action,-settings.ACTION_SCALE,settings.ACTION_SCALE)

    def update(self,states,actions,returns):
        '''
        performs one step of ADAM to train all networks involved
        Inputs:
            states: numpy array of state observations
            actions: numpy array of actions, actions[0] results in a state transition from states[0] to states[1]
            returns: the discounted return of each state - TD approximation for the value of a state
        Ouputs:
            critic_loss: value of the MSE loss function used to train the critic 
            actor_loss: value of the surrogate loss function used to train the actor    
        '''
        #print("actions: {}, states: {}, returns: {}".format(actions,states,returns))

        _1 = self.session.run(self.update_old_actor_op)

        adv = self.session.run(self.advantage_diff,{self.state_tf:states,self.return_tf:returns})

        [self.session.run(self.actor_train_op, {self.state_tf:states,self.action_tf:actions,self.return_tf:returns,self.adv_tf:adv}) for _ in range(settings.A_UPDATE_STEPS)]

        [self.session.run(self.critic_train_op, {self.state_tf:states,self.action_tf:actions,self.return_tf:returns,self.adv_tf:adv}) for _ in range(settings.C_UPDATE_STEPS)]

    def save(self):
        print("Saving checkpoint")
        save_path = os.path.join(settings.TRAIN_DIR,"Checkpoints","model.ckpt")
        self.saver.save(self.session, save_path, global_step=self.actor_step)
        
    def load(self):
        print("Loading checkpoint")
        save_path = os.path.join(settings.TRAIN_DIR)
        self.saver.restore(self.session, tf.train.latest_checkpoint(save_path)) 



