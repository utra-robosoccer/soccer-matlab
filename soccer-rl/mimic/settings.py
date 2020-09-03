#System Parameters
BOT_MODEL = "../soccer_description/models/soccerbot/model.xacro"
TRAIN_DIR = "/home/utra-art/soccer-rl/Train_Data"

#ACT/CRIT parameters
S_DIM = 3 
A_DIM = 1
C_LR = 0.0002
A_LR = 0.0001
ACTION_SCALE = 2

#PPO parameters
NUM_EPISODES = 100000
NUM_STEPS = 200
NUM_EPOCHS = 10
EXPSIZE = 32
MB_SIZE = 16
CLIP = 0.2 # as per ppo paper
GAMMA = 0.9
A_UPDATE_STEPS = 10
C_UPDATE_STEPS = 10


