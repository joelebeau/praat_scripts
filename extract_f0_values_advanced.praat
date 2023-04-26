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
# Ensure your TextGrid has 5 tiers. The first should be the phrase tier.
# The following tiers will be filled in with the following values:
#   2 - Minimum F0
#   3 - Maximum F0
#   4 - Mean F0
#   5 - Notes
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

beginPause("Change Pitch Settings")
  comment ("Primary Config")
  
  positive ("pitchFloor", 75)
  positive ("pitchCeiling", 500)
  
  comment ("Extra Stuff")
  real ("voicingThreshold", 0.45)
  real ("timeStep", 0)
  integer ("maxCandidates", 15)
  boolean ("veryAccurate", 0)
  real ("silenceThreshold", 0.03)
  real ("octaveCost", 0.01)
  real ("octaveJumpCost", 0.35)
  real ("voicedUnvoicedCost", 0.14)
endPause ("Ok", 1)

phraseTier = 1
minTier = 2
maxTier = 3
avgTier = 4
notesTier = 5

tgName$ = selected$ ("TextGrid")
sName$ = selected$ ("Sound")

selectObject: "Sound " + sName$
To Pitch (ac): timeStep, pitchFloor, maxCandidates, veryAccurate, silenceThreshold, voicingThreshold, octaveCost, octaveJumpCost, voicedUnvoicedCost, pitchCeiling

selectObject: "TextGrid " + tgName$
numIntervals = Get number of intervals: phraseTier

appendInfoLine: "phrase|minf0|maxf0|meanf0"
for i from 1 to numIntervals
	phrase$ = Get label of interval: phraseTier, i
	start = Get start time of interval: phraseTier, i
	end = Get end time of interval: phraseTier, i
	notes$ = Get label of interval: notesTier,  i

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
	appendInfoLine: phrase$ + "|" + minStr$ + "|" + maxStr$ + "|" + avgStr$ + "|" + notes$
endfor
