#!/bin/sh


#/usr/local/bin/TexturePacker \
        #--format spritekit \        
        #--texture-format png8 \
        #--variant 1:@2x \
        #--variant 0.70: \
        #--force-identical-layout \
        #--multipack \
        #--max-width 4096 \
        #--max-height 4096 \
        #--enable-rotation \
        #--data sprites.atlasc ./sprites


/usr/local/bin/TexturePacker --format spritekit --multipack --texture-format png8 --variant 1:@2x --variant 0.70: --force-identical-layout --max-width 4096 --max-height 4096 --enable-rotation --data cryptoNew.atlasc ./cryptoNew