# SOAP

### deactivateComputer.ps1
Deactivates a computer object and clears the warnings and errors on the computer object.
Use case: Migrating computer objects from one DSM to another DSM using dsa_control -r/-a.  The computer object in the old DSM console will go into an offline state.  This script can be run against the computer object in the old DSM console to clean up that object.

### get-ReconnaissanceDetected.ps1
Pulls reconnaissance detected events from the DSM and parses out the offending IP address.


