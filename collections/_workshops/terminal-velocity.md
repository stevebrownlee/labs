---
layout: workshop
title: "Terminal Velocity"
weight: 1
cost: "$350 USD"
categories: ["Development", "Terminal", "Automation", "Beginner"]
description: "Learn how to automate, configure, and customize your environment and applications with shell scripts."
thumbnail: "/assets/images/gen/packages/terminal-velocity-thumbnail.png"
image: "/assets/images/gen/packages/terminal-velocity.png"
---

## Prerequisites

1. If you use Visual Studio Code as your main editor, install the [shell-format](https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format) extension
2. Come with one of the following setups
	* Mac OS
	* Linux
	* Windows with [Ubuntu installed in WSL](https://learn.microsoft.com/en-us/windows/wsl/install)
3. Your account has admin access to run `sudo`
4. Have node and npm installed. We recommend that you use [Node Version Manager](https://github.com/nvm-sh/nvm#installing-and-updating) (nvm) to do this.
5. Have JSON Server installed with `npm i -g json-server`
6. Collaborative mindset - you will be working with teammates.
7. Know what your default shell environment is by running `echo $SHELL` in your terminal. It will likely be bash (/bin/sh) or zsh (/bin/zsh).

## Overview

The Terminal Velocity workshop will celebrate the wonderous joys of the bash interactive environment. You will go on a brief history of kernels, shells, and terminal emulators. Then you will embark on a journey of discovery about using aliases, functions, and bash scripts to accelerate and automate common tasks you do in your terminal.

You will use some commands and tools you likely have never used before.

* sed
* grep
* curl
* heredoc
* case
* PS3 prompt

You will be competent in the follow skills:

1.  Creating shell aliases for commonly used terminal commands that are cumbersome to type and remember.
2.  Authoring shell functions for common tasks that you perform in the terminal that involves a few processes, or requires some parameterization.
3.  Writing shell scripts that automate long, complex processes like building a consistent development environment, installing and configuring a sophisticated application, or setting up a cloud system consistently.
4.  Basic proficiency with the vim terminal editor program. Just enough to get your started and able to make simple changes in a text file.
5. Defining and using environment variables to customize how your functions and scripts behave depending on the user and/or the environment. Environment variables are also key to keeping sensitive data out of your code.

## Workshop Format

**Duration**: 8 hours

**Delivery**: Virtual


## Workshops Unlocked

**Terraform Your Cloud**

**Containers For Beginners**


 <!-- Replace "test" with your own sandbox Business account app client ID -->
 <script src="https://www.paypal.com/sdk/js?client-id=AU2T-_KiSEGLry9rRoWEtaXza2kWvdKR9mtSdqK0qY4Rh58yB3HtEsyFCgGgLHRk31Poi0N5eWPpC-xU"></script>

 <div id="paypal-button-container"></div>

<script>
  paypal.Buttons({
    createOrder: function(data, actions) {
      // Set up the transaction details
      return actions.order.create({
        purchase_units: [{
          amount: {
            value: '350.00'
          }
        }]
      });
    },
    onApprove: function(data, actions) {
      // Capture the transaction when the customer approves the payment
      return actions.order.capture().then(function(details) {
        // Redirect or show a success message to the customer
        alert('Transaction completed by ' + details.payer.name.given_name + '!');
      });
    }
  }).render('#paypal-button-container');
</script>
