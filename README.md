# deep-network-orthobiologics

This repository contains MATLAB m-files with code that trains various deep networks on orthobiologics data.  
It also contains an Excel file that holds all the orthobiologics data in our dataset: OrthobioDatasetV4.xlsx

The code, and further code derived from it, were used in for the project described in:  
Anastasio AT, Zinger BS, Anastasio TJ (in revision) A novel application of neural networks to identify potentially effective combinations of biologic factors for enhancement of bone fusion/repair

The purpose of this project was to: (1) gather data from the literature on orthobiologics (factors that enhance bone healing and repair); (2) assemble the data into a set of input/desired-output pairs suitable for machine learning via backpropagation-based algorithms; (3) establish a set of candidate neural network types; (4) find the optimal learning paramaters for each network type; (5) assess the ability of each network type to generalize over the dataset; (6) train a network of the best generalizing type on the whole dataset; and (7) use the trained network to predict which combinations of orthobiologic factors would best promote bone healing. 

Following is the list of files and a brief description of what they do:

OrthoSetUp.m          -- sets up all of the network types for training  
OrthoReadDataset.m    -- reads the data in the Excel file OrthobioDatasetV4.xlsx  
OrthoMakeTruthTable.m -- organizes the dataset into input/desired-output pairs for training

OrthoDeltaTrain.m     -- trains a two-layer (input-output) network on the dataset using delta rule  
OrthoDeltaTest.m      -- tests the two-layer network after training over the dataset  

OrthoBackOneTrain.m   -- trains a three-layer (one hidden layer) network on the dataset using backpropagation  
OrthoBackOneTest.m    -- tests the three-layer network after training over the dataset  

OrthoBackTwoTrain.m   -- trains a four-layer (two hidden layers) network on the dataset using backpropagation  
OrthoBackTwoTest.m    -- tests the four-layer network after training over the dataset  

[Networks with more layers of hidden units are easily created using the smaller network codes as templates.]  
[The following is a network having ten layers of hidden units, the largest feedforward network we considered.]  

OrthoBackTenTrain.m   -- trains a twelve-layer (ten hidden layers) network on the dataset using backpropagation  
OrthoBackTenTest.m    -- tests the twelve-layer network after training over the dataset  


