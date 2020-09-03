"""
"""
from __future__ import print_function

import os 
import sys 
import argparse 

import tensorflow as tf 

import settings 
import agent 
import simulation 


def run_simulation(sim):
    """
    """
    pass 




if __name__ == '__main__':
    
    parser = argparse.ArgumentParser(description="start a simulation")
    parser.add_argument('-a', '--action', default="train", help="train or test")
    parser.add_argument('-p', '--params', default="params.yaml", help="training parameters")
    args = parser.parse_args()
    print(args)

    # robot and simulation setup 
    bot = agent.Robot(settings.BOT_MODEL)
    sim = simulation.SoccerSim(bot)

    # main execution 
    run_simulation(sim)


  