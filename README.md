# tUtility
This procedure (tUtility) offers a GUI (control panel) for general purpose analyses with necessory library.
It is written for analyses and figure preparation of in vitro patch-clamp data.
But it can be utilized for other analyses including in vivo intra- and extracellular recordings, calcium imagings etc.

## Getting Started

### Prerequisites
* Igor Pro 6 (https://www.wavemetrics.com/)
* PPT.XOP (http://www.mpibpc.mpg.de/groups/neher/index.php?page=software)
* SetWindowExt.XOP (https://github.com/yuichi-takeuchi/SetWindowExt)

This code has been tested in Igor Pro version 6.3.7.2. for Windows and supposed to work in Igor Pro 6.1 or later.

### Installing
1. Install Igor Pro 6.1 or later.
2. Put GlobalProcedure.ipf or its shortcut into the Igor Procedures folder, which is normally located at My Documents\WaveMetrics\Igor Pro 6 User Files\Igor Procedures.
3. Optional: Put PPT.xop and SetWindowExt.xop or their shortcuts into the Igor Extensions folder, which is normally located at My Documents\WaveMetrics\Igor Pro 6 User Files\Igor Extensions.
4. Optional: Put PPT Help.ihf and SetWindowExt Help.ipf or their shortcuts into the Igor Help Files folder, which is normally located at My Documents\WaveMetrics\Igor Pro 6 User Files\Igor Help Files.
5. Restart Igor Pro.

### How to initialize the tUtility GUI
* For initialization, click "NewControlPanel" in tUtility of Menu. A GUI window named ControlPanel will appear. Global variables etc. are stored in root:Packages:YT:.
* The ControlPanel window can be minimized and recall by "DisplayControlPanel" in tUtility of Menu.
* The sorce code for callback functions for the control panel can be found in the GlobalProcedure.ipf, which can be called by "GlobalProcedure.ipf" in tUtility of Menu.

### Principle
There are two tab groups on the control panel. The upper group includes "V&S (Variable & String)" tab and JW tab. 02-04 tabs are under constructions. The lower group includes "Gen (General)", "Edit", "Analy (Analysis)", "CC (Current Clamp)", "VCA (Voltage Clamp Analysis)", "TCA (Time Course Analysis)". Buttons on Gen tab generally exert cosmetic things on existing waves (eg. display). Buttons on the edit tab may modify existing waves: make, duplicate, rename, kill, concatenate waves. Buttons on the Analy tab couduct statistical procedures: average waves on the target wave list etc. Controls on the CC tab are used to analyze current clamp data: action potential detection, measurement of action potential amplitudes etc. Controls on the VCA tab is used to analyze voltage clamp data especially evoked EPSC or IPSCs: measurement of PSC amplitude and decay time etc. Controls on the TCA are used to analyze longitudinal data of evoked synaptic currents or potentials etc.

### The principle of usage
1. Specify target window(s) or target wave(s) in the SetVariable control in the V&S tab.
2. Run a function by pressing a botton on the control panel.

### Examples
* Set target window as a string of the name of existing window for example "Graph0", and then press "RNtWin" button on the V&S tab. You can rename the Graph0 with prompt.
* Collect names of windows into the target window list by "tWin>L" button, and then press "DW/KL" button. You can kill windowns on the target window list.
* Set target wave0 as a string of name of a wave in the current data folder (eg. "wave0"), and then press "Disp" button in the Gen tab. You can display the target wave in a new graph.
* Set target window as a string of the name of existing window for example "Graph0" and set target wave0 as a string of name of a wave in the current data folder (eg. "wave0"). After that press "ATG" button in the Gen tab. You can append the target wave to the target window (graph).

## DOI
[![DOI](https://zenodo.org/badge/93492175.svg)](https://zenodo.org/badge/latestdoi/93492175)

## Versioning
We use [SemVer](http://semver.org/) for versioning.

## Releases
* Ver 1.0.0, 2017/06/06

## Authors
* **Yuichi Takeuchi PhD** - *Initial work* - [GitHub](https://github.com/yuichi-takeuchi)

## License
This project is licensed under the MIT License.

## Acknowledgments
* Department of Physiology, Tokyo Women's Medical University, Tokyo, Japan
* Department of Information Physiology, National Institute for Physiological Sciences, Okazaki, Japan

## References
tUtility has been used for the following works:
- Nagumo Y, Takeuchi Y, Imoto K, Miyata M (2011) Synapse- and subtype-specific modulation of synaptic transmission by nicotinic acetylcholine receptors in the ventrobasal thalamus. Neurosci Res 69: 203-213.
- Takeuchi Y, Yamasaki M, Nagumo Y, Imoto K, Watanabe M, Miyata M (2012) Rewiring of afferent fibers in the somatosensory thalamus of mice caused by peripheral sensory nerve transection. J Neurosci 32: 6917-6930.
- Takeuchi Y, Asano H, Katayama Y, Muragaki Y, Imoto K, Miyata M (2014) Large-scale somatotopic refinement via functional synapse elimination in the sensory thalamus of developing mice. J Neurosci 34: 1258-1270.
- Takeuchi Y, Osaki H, Yagasaki Y, Katayama Y, Miyata M (2017) Afferent Fiber Remodeling in the Somatosensory Thalamus of Mice as a Neural Basis of Somatotopic Reorganization in the Brain and Ectopic Mechanical Hypersensitivity after Peripheral Sensory Nerve Injury. eNeuro 4: e0345-0316.
- Nagumo Y, Ueta Y, Nakayama H, Osaki H, Takeuchi Y, Uesaka N, Kano M, Miyata M (2020) Tonic GABAergic inhibition is essential for nerve injury-induced afferent remodeling in the somatosensory thalamus and associated ectopic sensations. Cell Rep 31: 107797.
