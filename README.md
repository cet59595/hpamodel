# hpamodel
A R Shiny interface for the HPA axis model from Walker et al., PLoS Biology 2012.

This was developed during as a tool for teaching about HPA axis dynamics in the context of the Introduction to Biomedical Sciences course at the Edinburgh-Zhejang Institute in Haining, China.

Two PDF with the instructions for the tutorial (one for students, one for tutors) are available in the repository, under a CC-BY-SA 4.0 licence.

The R code used to produce the interface is licensed under the GPL 3.0 license.

If you are only interested in running the software (as opposed to modifying it) you can find a ready-to-use online version at this address: https://nicolaromano.shinyapps.io/hpamodel/

-----------------------------

INSTALLATION INSTRUCTIONS

1. Install R from https://www.r-project.org/
2. Install R Studio from https://www.rstudio.com/
3. The following packages needs to be installed (via the R Studio interface or the install.packages command): shiny, deSolve
4. Put the ui.R and server.R files in a directory of your choice. ui.R contains the code to generate the graphical interface, while server.R contains the backend that does all of the needed calculations. More informations about the model can be found in: Walker et al., Proc Biol Sci. 2010; Walker et al., PLoS Biol 2012; Rankin et al., PLoS One 2012   
5. Open either file in R Studio and press "Run app"
