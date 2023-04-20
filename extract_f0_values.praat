# Extracts min, max, and mean f0 values.
#
# Author: Joe LeBeau
# https://www.github.com/joelebeau
#  
# First - Ensure that you have made backups of your TextGrid file. If
# something goes wrong the original data will most likely not be
# recoverable, so keep a pristine backup of any data you want to keep.
#
# ***************************************************************
# ** This script will overwrite any data in tiers 2, 3, and 4. **
# ***************************************************************
# 
# Preparing your TextGrid
#
# Ensure your TextGrid has 4 tiers. The first should be the phrase tier.
# The following tiers will be filled in with the following values:
#   2 - Minimum F0
#   3 - Maximum F0
#   4 - Mean F0
# The tier names do not matter as long as they are in this order.
# Identify your phrases and add boundaries for each phrase on ALL tiers.
#
# Running the Script
#
# Open your TextGrid and Sound file in the Praat Object window
# and make sure that both are selected. Open this script via 
# Praat -> Open Praat script... . Next, in the script window select
# Run -> Run. The values will be filled into the TextGrid, and the
# script info window will show the values in a pipe-separated format
# that may be saved as a .psv file and imported into a spreadsheet
# program.
#
# The script will create a Pitch object in the object window. This can
# be safely removed.

clearinfo

form Set pitch floor / ceiling values
  positive pitchFloor 60
  positive pitchCeiling 350
endform

pitchTimeStep = 0

phraseTier = 1
minTier = 2
maxTier = 3
avgTier = 4

tgName$ = selected$ ("TextGrid")
sName$ = selected$ ("Sound")

selectObject: "Sound " + sName$
To Pitch: pitchTimeStep, pitchFloor, pitchCeiling

selectObject: "TextGrid " + tgName$
numIntervals = Get number of intervals: phraseTier

appendInfoLine: "phrase|minf0|maxf0|meanf0"
for i from 1 to numIntervals
	phrase$ = Get label of interval: phraseTier, i
	start = Get start time of interval: phraseTier, i
	end = Get end time of interval: phraseTier, i

	select Pitch 'sName$'
	min = Get minimum: start, end, "Hertz", "Parabolic"
	max = Get maximum: start, end, "Hertz", "Parabolic"
	avg = Get mean: start, end, "Hertz"
	minStr$ = string$ (min)
	maxStr$ = string$ (max)
	avgStr$ = string$ (avg)
	
	selectObject: "TextGrid " + tgName$
	Set interval text: minTier, i, minStr$
	Set interval text: maxTier, i, maxStr$
	Set interval text: avgTier, i, avgStr$
	appendInfoLine: phrase$ + "|" + minStr$ + "|" + maxStr$ + "|" + avgStr$
endfor
