#!/bin/bash

usb_device_database=(
    ## Every line has $tokens_on_line (currently 3) tokens:
    ##   "vendor:devid"   "driver"   "optional-driver"
    ##
    ## Important: use empty string "" for each missing token.
    
    # Brother multifunction: printer and scanner drivers:
    04f9:0422  brother-dcp-l2537dw-printer  brscan4
)
