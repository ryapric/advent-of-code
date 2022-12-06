#!/usr/bin/env -S gawk -f

{
  print "I could not, for the life of me, get this to work, GROSS"
}

# # Store the starting stacks that we'll manipulate later
# $0 ~ /^.*\[/ {
#   stack_count = NF

#   # This lets us pad out boxes in the stack with empty space to their left, so
#   # that we can accurately assign a box to a stack based on the field delimiter
#   gsub(/\s\s\s\s/, "[-] ")

#   for (stack = 1 ; stack <= stack_count ; stack++) {
#     # And now, fuck that shit
#     if ($stack != "[-]") {
#       stacks[stack "," NR] = $stack
#     }
#   }
# }

# # Grab the instructions themselves
# $0 ~ /^move/ {
#   split($0, instruction_i)

#   # Ugly, but this will operate on the instruction *numbers* in the array, which
#   # also includes the *words* post-split
#   instructions[NR] = instruction_i[2] "," instruction_i[4] "," instruction_i[6]
# }

# END {
#   # So NOW, we want to know the most boxes that could possibly be in a stack
#   # (which we couldn't know until we processed all the boxes in the first
#   # place), so that we can assign the respective "maximum" index values to each
#   # array value to prevent from needing to do that as we move boxes later. We
#   # just need to operate on the second part of the index, since the first part
#   # is the stack index itself, and won't change.
#   max_boxes_in_stack = length(stacks)
#   for (stack_index in stacks) {
#     split(stack_index, index_old, ",")
#     stack_number = index_old[1]
#     box_number_old = index_old[2]
#     box_number_new = (box_number_old + (max_boxes_in_stack - box_number_old)) # 6 -
#     index_new = stack_number "," box_number_new
#     stacks[index_new] = stacks[stack_index]

#     print "box: " stacks[stack_index]
#     print "old index: " stack_index
#     print "new index: " index_new

#     delete stacks[stack_index]
#   }

#   for (inst in instructions) {
#     split(instructions[inst], inst_i, ",")
#     print "Captured instruction: " instructions[inst]
#     print "Instruction, separated: " inst_i[1] " " inst_i[2] " " inst_i[3]
#   }

#   for (stack_index in stacks) {
#     print "Index: ", stack_index ", value: " stacks[stack_index]
#   }

#   print stack_count
# }
