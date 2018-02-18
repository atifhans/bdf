#!/usr/bin/env python2

import os
import sys
import subprocess

from subprocess import call

def gen_syn_script(name, clk):
    with open('cfg/runsynth_template.tcl', 'r') as file :
        filedata = file.read()

    filedata = filedata.replace('{ARG0}', name)
    filedata = filedata.replace('{CLK}' , str(clk))

    with open('synth/runsynth.tcl', 'w') as file:
        file.write(filedata)

    return "synth/" + name + ".txt"

def gen_sim_script(name):
    with open('cfg/runsim_template', 'r') as file :
        filedata = file.read()

    filedata = filedata.replace('{ARG0}', name)

    with open('sim/runsim', 'w') as file:
        file.write(filedata)

    os.chmod('sim/runsim', 0777)

    return "sim/" + name + ".txt"

def run_syn(name, clk):
    lname = gen_syn_script(name, clk)
    os.chdir("synth")
    subprocess.call(["dc_shell", "-f", "runsynth.tcl"])
    #p1 = subprocess.Popen(["dc_shell", "-f", "synth/runsynth.tcl"], stdout=subprocess.PIPE)
    #p2 = subprocess.Popen(["tee", lname], stdin=p1.stdout, stdout=subprocess.PIPE)
    #p1.stdout.close()
    #p2.communicate()
    os.chdir("..")

    #with open(lname) as f:
    #    for line in f:
    #        if "Error" in line:
    #            print line
    #        elif "/CK" in line:
    #            print line
    #        elif "Warning" in line and "signed" not in line and "tran" not in line:
    #            print line
    #        elif "Total" in line and "undefined" not in line and "Dynamic" not in line:
    #            print line
    #        elif "slack" in line:
    #            print line

def run_sim():
    lname = gen_sim_script(name)
    os.chdir("sim")
    subprocess.call(["./runsim"])
    #p1 = subprocess.Popen(["./runsim"], stdout=subprocess.PIPE)
    #p2 = subprocess.Popen(["tee", lname], stdin=p1.stdout, stdout=subprocess.PIPE)
    #p1.stdout.close()
    #p2.communicate()
    os.chdir("..")

    #with open(lname) as f:
    #    for line in f:
    #        if "errors" in line:
    #            print line
    #        elif "Throughput" in line:
    #            print line

def print_usage():
    print sys.argv[0] + " flow [Top Module] [Clock]"
    print "flow:  sim, syn"
    print "<sim> target expects top module name only"
    print "<syn> target requires both top module and clock"

if(len(sys.argv) == 1):
    print "Invalid number of arguments"
    print_usage()
    sys.exit(0)
else:
    flow = sys.argv[1]

if flow == "syn":
    if(len(sys.argv) < 4):
        print "Invalid number of arguments"
        print_usage()
        sys.exit(0)
    name = sys.argv[2]
    clk  = float(sys.argv[3])
    print "Running Synthesis on module " + name + "with clock period: " + str(clk)
    run_syn(name, clk)
elif flow == "sim":
    if(len(sys.argv) < 3):
        print "Invalid number of arguments"
        print_usage()
        sys.exit(0)
    name = sys.argv[2]
    print "Running Simulation on module " + name
    run_sim()
elif flow == "clean":
    print "Cleaning Temp Files!"
    subprocess.call(["rm", "-rf", "synth/*", "sim/*"])
else:
    print "Invalid Argument: " + flow


