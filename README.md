# deep-network-orthobiologics

This repository contains MATLAB m-files with code that trains various deep networks on orthobiologics data.  
It also contains an Excel file that holds all the orthobiologics data in our dataset: OrthobioDatasetV4.xlsx

The code, and further code derived from it, were used for the project described in:  
Anastasio AT, Zinger BS, Anastasio TJ (in revision) A novel application of neural networks to identify potentially effective combinations of biologic factors for enhancement of bone fusion/repair.

The purpose of this project was to: (1) gather data from the literature on orthobiologics (factors that enhance bone healing and repair); (2) assemble the data into a set of input/desired-output pairs suitable for machine learning via backpropagation-based algorithms; (3) establish a set of candidate neural network types; (4) find the optimal learning paramaters for each network type; (5) assess the ability of each network type to generalize over the dataset; (6) train a network of the best generalizing type on the whole dataset; and (7) use the trained network to predict which combinations of orthobiologic factors would best promote bone healing. 

Following is the list of files and a brief description of what they do:

OrthoSetUp.m                -- sets up all of the network types for training  
OrthoReadDataset.m          -- reads the data in the Excel file OrthobioDatasetV4.xlsx  
OrthoMakeTruthTable.m       -- organizes the dataset into input/desired-output pairs for training  

OrthoDeltaTrain.m           -- trains a two-layer (input-output) network on the dataset using delta rule  
OrthoDeltaTest.m            -- tests the two-layer network after training over the dataset  

OrthoBackOneTrain.m         -- trains a three-layer (one hidden layer) network on the dataset using backpropagation  
OrthoBackOneTest.m          -- tests the three-layer network after training over the dataset  

OrthoBackTwoTrain.m         -- trains a four-layer (two hidden layers) network on the dataset using backpropagation  
OrthoBackTwoTest.m          -- tests the four-layer network after training over the dataset  

[Networks with more layers of hidden units are easily created using the smaller network codes as templates.]  
[The following is a network having ten layers of hidden units, the largest feedforward network we considered.]  

OrthoBackTenTrain.m         -- trains a twelve-layer (ten hidden layers) network on the dataset using backpropagation  
OrthoBackTenTest.m          -- tests the twelve-layer network after training over the dataset  

OrthoRecurTrain.m           -- trains a recurrent network on the dataset using backpropagation  
OrthoRecurTest.m            -- tests the recurrent network after training over the dataset  

OrthoAutoTrain.m            -- trains an autoencoder network on the dataset using backpropagation  
OrthoAutoTest.m             -- tests the autoencoder network after training over the dataset  

OrthoGenError.m             -- finds network generalization error by dividing dataset into training and testing set  
OrthoParamEval.m            -- finds network generalization error over ranges of learning algorithm parameters  

OrthoMakeCombos.m           -- makes combinations of input factors whose efficacy a network should predict
OrthoBackTwoAutoRunCombos.m -- makes predictions using a network with an autoencoded input and two hidden layers

[We found that a neural network composed of and input layer, an autoencoder layer, two hidden layers, and an output layer  
generalized best over the dataset. This network type was used to make predicitons on combinations of orthobiologic factors.]  
