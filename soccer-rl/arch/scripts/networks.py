# Brian Aly - brian.aly@mail.utoronto.ca 

import sys
import settings
import tensorflow as tf
import numpy as np

class Critic_MLP(object):

    def __init__(self, scope, units, activations, trainable, reuse=False):
        '''
        Inputs:
            scope: name to use for tf scopes
            units: list containing number of hidden units per layer, units[0] = number of input features
            activations: list containing activations to be used, activations[0] = None 
            trainable: wether or not the network should be trainable  
            reuse: wether tf variables should be reused with multiple objects of this class
        '''

        self.scope = scope
        self.units = units
        self.activations = activations
        self.trainable = trainable
        self.reuse = reuse
        self.outputs = [None]
        self.params = None
    
    def build_graph(self,state,global_step):
        '''
        Builds the computation graph for the critic
        Inputs:
            states: tf placeholder inputs to network
        '''
        
        self.global_step = global_step
        self.outputs = [state]
        with tf.variable_scope(self.scope, reuse=self.reuse):
            for i in range(1,len(self.units)-1):
                layer = tf.layers.dense(self.outputs[i-1], self.units[i], tf.nn.relu, trainable=self.trainable)
                self.outputs.append(layer)
            layer = tf.layers.dense(self.outputs[-1], self.units[-1], trainable=self.trainable)
            self.outputs.append(layer)
        self.params = tf.get_collection(tf.GraphKeys.GLOBAL_VARIABLES, scope=self.scope)

class Actor_MLP(object):

    def __init__(self, scope, units, activations, trainable, reuse=False):
        '''
        Inputs:
            scope: name to use for tf scopes
            units: list containing number of hidden units per layer, units[0] = N
            activations: list containing activations to be used, activations[0] = None  
            trainable: wether or not the network should be trainable  
            reuse: wether tf variables should be reused with multiple objects of this class
        '''
        self.scope = scope
        self.units = units
        self.activations = activations
        self.trainable = trainable
        self.reuse = reuse
        self.outputs = [None]
        self.norm_dist = None
        self.params = None

    def build_graph(self,state,global_step):
        '''
        Builds the computation graph for the critic
        Inputs:
            states: tf placeholder inputs to network
        '''  

        self.global_step = global_step
        self.outputs = [state]
        with tf.variable_scope(self.scope, reuse=self.reuse):
            for i in range(1,len(self.units)-1):
                layer = tf.layers.dense(self.outputs[i-1], self.units[i], tf.nn.relu, trainable=self.trainable)
                self.outputs.append(layer)
            mu = settings.ACTION_SCALE * tf.layers.dense(self.outputs[-1], self.units[-1], tf.nn.tanh, trainable=self.trainable) 
            sigma = tf.layers.dense(self.outputs[-1], self.units[-1], tf.nn.softplus, trainable=self.trainable) 
            self.outputs.append([mu,sigma])

            self.norm_dist = tf.distributions.Normal(loc=mu,scale=sigma) 
        self.params = tf.get_collection(tf.GraphKeys.GLOBAL_VARIABLES, scope=self.scope)

