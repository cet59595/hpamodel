# Shiny interface to HPA axis model
# Based on Walker et al. PLoS Biol 2012
# Copyright (C) 2017 Nicola Romano'
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

library(shiny)

shinyUI(
  fluidPage
      (
      titlePanel("HPA axis model"),
  
      sidebarLayout
        (
        sidebarPanel
            (
            p("This model is based on Walker et al., PLoS Biology 2012"),
            p("It has been adapted by Nicola Romano and is freely distributed under the GPL3 licence"),
            p("Parameters of the model"),
            numericInput("simLen", "Simulation length (h)", min = 1, 
                         max = 72, value = 6),
            numericInput("CRH", "Hypothalamic CRH (AU)", min = 0, max = 80, 
                        step = 0.5, value = 20),
            numericInput("tau", "Adrenal delay (min)", min = 0, max = 60, 
                        step = 0.1, value = 10),
            checkboxInput("doStress", "Add a stressor", value = F),
            numericInput("stressFrom", "Stress start (h)", value = 1),
            numericInput("stressLen", "Stress length (min)", value = 5)
            ), # sidebarPanel
          
        mainPanel
            (
            plotOutput("modelPlot", height = "450px")
            ) # mainPanel
      ) # sidebarLayout
    ) # fluidPage
  ) # shinyUI