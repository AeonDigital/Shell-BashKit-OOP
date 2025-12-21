#!/usr/bin/env bash

#
# Type of the objects.
unset BASHKIT_MAIN_OBJECT_TYPES
declare -gA BASHKIT_MAIN_OBJECT_TYPES

#
# Instances of the objects.
unset BASHKIT_MAIN_OBJECT_INSTANCES
declare -gA BASHKIT_MAIN_OBJECT_INSTANCES

#
# Instances of the objects.
unset BASHKIT_MAIN_OBJECT_INSTANCES_VALUES
declare -gA BASHKIT_MAIN_OBJECT_INSTANCES_VALUES

#
# List of available property types
unset BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES
declare -ga BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES=()
BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES+=("bool")
BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES+=("int")
BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES+=("float")
BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES+=("string")
BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES+=("array")
BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES+=("assoc")


#
# Assoc array thats contain all constructors defined for all types of objects.
#
unset BASHKIT_MAIN_OBJECT_TYPE_CONSTRUCTORS
declare -gA BASHKIT_MAIN_OBJECT_TYPE_CONSTRUCTORS


#
# Assoc array thats contain all properties defined for all types of objects.
#
# Each new object gains an entry in this array with its own name, and in this 
# location, the names of all defined properties can be found separated by ';'
#
# Each property of object is prefixed with your parent type name and
# has the keys above:
# - <typeName>_<propName>
# - <typeName>_<propName>_name
# - <typeName>_<propName>_type
# - <typeName>_<propName>_default
#
unset BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES
declare -gA BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES


#
# Assoc array thats contain all methods defined for all types of objects.
#
# Each new object gains an entry in this array with its own name, and in this 
# location, the names of all defined methods can be found separated by ';'
#
# Each method of object is prefixed with your parent type name and
# has the keys above:
# - <typeName>_<methodName>
# - <typeName>_<methodName>_name
unset BASHKIT_MAIN_OBJECT_TYPE_METHODS
declare -gA BASHKIT_MAIN_OBJECT_TYPE_METHODS