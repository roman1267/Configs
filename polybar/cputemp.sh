#!/bin/bash
sensors | grep 'CPU' | tr -d [:space:] | tr -d [:alpha:] | tr -d ":+" | tr -d "°"
