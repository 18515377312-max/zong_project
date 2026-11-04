#!/usr/bin/env yosys-tcl
proc pmux_extract {} {
    puts "\nINFO: Start pmux_extract, detect mux tree"
    yosys select -clear
    yosys select {$mux:*}
    set total_mux [yosys select -count]
    puts "INFO: Found total mux cells: $total_mux"
    if {$total_mux == 0} {
        puts "WARNING: No \$mux cells found! proc/opt已经把多路器展开成门电路了。"
        return
    }
    yosys select -set pmux_tree_group
    set tree_size [yosys select -count pmux_tree_group]
    puts "INFO: Nodes in mux tree group: $tree_size"
    puts "INFO: pmux_extract finished"
}

proc pmux_prune_redundant {} {
    puts "\nINFO: Start pmux_prune_redundant"
    puts "INFO: pmux_prune_redundant finished"
}

proc pmux_rebuild_equivalent {} {
    puts "\nINFO: Start pmux_rebuild_equivalent"
    puts "INFO: pmux_rebuild_equivalent finished"
}

pmux_extract
pmux_prune_redundant
pmux_rebuild_equivalent

puts "==== PMUX Tcl script finished ===="