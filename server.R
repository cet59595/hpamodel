# Shiny interface to HPA axis model
# Based on Walker et al. PLoS Biol 2012
# Copyright (C) 2017 Nicola Romano
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
library(deSolve)

# Little helper function for outputting stats
fmt <- function(num, dig = 2)
  {
  format(num, nsmall = dig, digits = dig, scientific = FALSE)
  }

# The parameters of the model
params <- c(CRH = 20,
            p2 = 15,
            p3 = 7.2,
            p4 = 0.05,
            p5 = 0.11,
            p6 = 2.9,
            tau = 0.9627
            )

InitialState  <- c(A = 0, R = 0.01, O = 0)

# Convert between dimensionless and dimensional time units
# Following equation (10) in the supplementary data of 
# Walker et al. PLoS Biol 2012
# t(dimensionless) = ln(2) / CORT1/2 * T(dimensional)
# with CORT1/2 ~= 7-10 min
dimless2dim <- function(t)
  {
  CORT12 <- 8/60 # 10 min in hours
  CORT12 / log(2) * t
  }

dim2dimless <- function(t)
  {
  CORT12 <- 8/60 # 10 min in hours
  log(2) / CORT12 * t
  }

HPAModel <- function(t, state, parameters, perturb)
  {
  with(as.list(c(state, parameters)),
       {
       tlag <- t - tau
       
       if (!is.null(perturb))
          {
          if (t > perturb$start && t < perturb$end)
               CRH <- perturb$intensity
          }
       
       if (tlag <= 0)
          Alag <- .1
       else
          Alag <- lagvalue(tlag, 1)

       # ACTH - pituitary
       dA <- CRH / (1 + p2 * R * O) - p3 * A
       # GR - pituitary
       dR <- (O^2 * R^2) / (p4 + (O^2 * R^2)) + p5 - p6 * R
       # CORT - adrenal
       dO <- Alag - O
       # return the rate of change
       list(c(dA, dR, dO))
       })
  }


shinyServer(function(input, output, clientData, session)
  {
  output$modelPlot <- renderPlot(
      {
      params["CRH"] <- input$CRH
      params["tau"] <- dim2dimless(input$tau / 60)

      times <- seq(0, input$simLen, 1/60) # step 1 min
      # Convert to dimensionless units
      times <- dim2dimless(times)

      # Check if we are adding a stress
      if (input$doStress)
        {
        # Read the stress start and end time from the UI sliders
        perturb = data.frame(start = dim2dimless(input$stressFrom), 
                             end = dim2dimless(input$stressFrom + input$stressLen / 60),
                             intensity = 200)
        # Run the model
        out <- dede(y = InitialState, times = times, func = HPAModel,
                    parms = params, perturb = perturb)  
        out.nostress <- dede(y = InitialState, times = times, func = HPAModel,
                    parms = params, perturb = NULL)  
        }
      else
        {
        # Run the model
        out <- dede(y = InitialState, times = times, func = HPAModel, 
                   parms = params, perturb = NULL)
        out.nostress <- NULL
        }
      
      plot(A ~ times, out, t = "l", lwd = 2, col = "orange", ylab = "ACTH/CORT (AU)",
           xlab = "Time (hours)", xlim = c(0, dim2dimless(input$simLen)),  
           las = 1, bty = "n", xaxt = "n")
      ticks <- seq(0, input$simLen, length.out = 5)
      axis(1, at = dim2dimless(ticks), ticks) 

      lines(O ~ times, out, t = "l", lwd = 2, col = "navy")
      if (!is.null(out.nostress))
        lines(O ~ time, out.nostress, t = "l", lwd = 2, 
              col = "gray", lty = "dashed")
        
      legend("topright", c("ACTH", "Cortisol"), lwd = 2, col = c("orange", "navy"))
      }
    )
  }) # end shinyServer
