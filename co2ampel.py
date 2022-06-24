#!/usr/bin/env python3

import json
from scd30_i2c import SCD30
import sys
import os
import colorsys
import time
import ST7735
from PIL import Image, ImageDraw, ImageFont
from fonts.ttf import RobotoMedium as UserFont
import logging

scd30 = SCD30()
if (scd30.get_auto_self_calibration_active() != 1):
    scd30.set_auto_self_calibration(1)
scd30.start_periodic_measurement()


# Create LCD class instance.
disp = ST7735.ST7735(
    port=0,
    cs=1,
    dc=9,
    backlight=12,
    rotation=270,
    spi_speed_hz=10000000
)

# Initialize display.
disp.begin()

# Width and height to calculate text position.
WIDTH = disp.width
HEIGHT = disp.height

# New canvas to draw on.
img = Image.new('RGB', (WIDTH, HEIGHT), color=(0, 0, 0))
draw = ImageDraw.Draw(img)

# Text settings.
font_size = 50
font = ImageFont.truetype(UserFont, font_size)


text_colour = (0, 0, 0)


# Keep running.
try:
    while True:
        if scd30.get_data_ready():
            data_raw_scd30 = scd30.read_measurement()
        if data_raw_scd30 is not None:
            [float_co2, float_T, float_rH] = data_raw_scd30
        scd30_co2 = float_co2
        scd30_temp = float_T
        scd30_hum = float_rH

        if (scd30_co2 < 650):
            back_colour = (0, 255, 0)
        elif (scd30_co2 < 1000):
            back_colour = (255, 255, 0)
        elif (scd30_co2 > 1000):
            back_colour = (255, 0, 0)
        else:
            back_colour = (255, 255, 255)

        message = str(int(scd30_co2))
        size_x, size_y = draw.textsize(message, font)

        # Calculate text position
        x = (WIDTH - size_x) / 2
        y = (HEIGHT / 2) - (size_y / 2)

        # Draw background rectangle and write text.
        draw.rectangle((0, 0, 160, 80), back_colour)
        draw.text((x, y), message, font=font, fill=text_colour)
        disp.display(img)
        print(message)
        time.sleep(2.5)


# Turn off backlight on control-c
except KeyboardInterrupt:
    disp.set_backlight(0)
