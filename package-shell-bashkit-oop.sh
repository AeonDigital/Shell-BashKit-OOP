#!/usr/bin/env bash

#
# mounted by Shell-BashKit-Shrink in 2025-12-25 22:59:37


unset BASHKIT_MAIN_OBJECT_TYPES
declare -gA BASHKIT_MAIN_OBJECT_TYPES
unset BASHKIT_MAIN_OBJECT_INSTANCES
declare -gA BASHKIT_MAIN_OBJECT_INSTANCES
unset BASHKIT_MAIN_OBJECT_INSTANCES_VALUES
declare -gA BASHKIT_MAIN_OBJECT_INSTANCES_VALUES
unset BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES
declare -ga BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES=()
BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES+=("bool")
BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES+=("int")
BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES+=("float")
BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES+=("string")
BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES+=("array")
BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES+=("assoc")
unset BASHKIT_MAIN_OBJECT_TYPE_CONSTRUCTORS
declare -gA BASHKIT_MAIN_OBJECT_TYPE_CONSTRUCTORS
unset BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES
declare -gA BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES
unset BASHKIT_MAIN_OBJECT_TYPE_METHODS
declare -gA BASHKIT_MAIN_OBJECT_TYPE_METHODS
objectCheckTypeExists() {
  local typeObject="${1}"
  if [ "${BASHKIT_MAIN_OBJECT_TYPES[${typeObject}]}" == "" ]; then
    return "1"
  fi
  return "0"
}
objectCheckTypeInDefinitionMode() {
  local typeObject="${1}"
  if [ "${BASHKIT_MAIN_OBJECT_TYPES[${typeObject}]}" == "definitionMode" ]; then
    return "0"
  fi
  return "1"
}
objectCheckTypePropertyExists() {
  local typeObject="${1}"
  local typePropName="${2}"
  local regTypePropName="${typeObject}_${typePropName}"
  if [ "${BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES[${regTypePropName}]}" == "-" ]; then
    return "0"
  fi
  return "1"
}
objectCheckTypeMethodExists() {
  local typeObject="${1}"
  local typeMethodName="${2}"
  local regTypeMethodName="${typeObject}_${typeMethodName}"
  if [ "${BASHKIT_MAIN_OBJECT_TYPE_METHODS[${regTypeMethodName}]}" == "-" ]; then
    return "0"
  fi
  return "1"
}
objectCheckPropertyValue() {
  local propertyType="${1}"
  local propertyValue="${2}"
  if [ "${propertyValue}" != "" ]; then
    case "${propertyType}" in
      "bool")
        if ! varIsBool "${propertyValue}"; then
          return "1"
        fi
        ;;
      "int")
        if ! varIsInt "${propertyValue}"; then
          return "1"
        fi
        ;;
      "float")
        if ! varIsFloat "${propertyValue}"; then
          return "1"
        fi
        ;;
      "array")
        if ! varIsArray "${propertyValue}"; then
          return "1"
        fi
        ;;
      "assoc")
        if ! varIsAssoc "${propertyValue}"; then
          return "1"
        fi
        ;;
    esac 
  fi
  return "0"
}
objectCheckInstanceExists() {
  local typeObject="${1}"
  local typeInstanceName="${2}"
  if [ "${BASHKIT_MAIN_OBJECT_TYPES[${typeObject}]}" == "" ]; then
    return "1"
  fi
  local regTypeInstanceName="${typeObject}_${typeInstanceName}"
  if [ "${BASHKIT_MAIN_OBJECT_INSTANCES[${regTypeInstanceName}]}" == "" ]; then
    return "1"
  fi
  return "0"
}
objectMetaProperty() {
  local typeObject="${1}"
  if ! objectCheckTypeExists "${typeObject}"; then
    messageError "Object type is not defined | '${typeObject}'"
    return "1"
  fi
  local typePropName="${2}"
  if ! objectCheckTypePropertyExists "${typeObject}" "${typePropName}"; then
    messageError "Property is not defined for object type | '${typeObject}.${typePropName}'"
    return "1"
  fi
  if ! varIsAssoc "${3}"; then
    messageError "Return assoc not exists or is not an assoc array | '${3}'"
    return "1"
  fi
  local regTypePropName="${typeObject}_${typePropName}"
  local -n tmpMetaPropArray="${3}"
  tmpMetaPropArray["name"]="${typePropName}"
  tmpMetaPropArray["type"]="${BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES["${regTypePropName}_type"]}"
  tmpMetaPropArray["default"]="${BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES["${regTypePropName}_default"]}"
  return "0"
}
objectMetaTypeGetProperties() {
  local typeObject="${1}"
  if ! objectCheckTypeExists "${typeObject}"; then
    messageError "Object type is not defined | '${typeObject}'"
    return "1"
  fi
  if ! varIsArray "${2}"; then
    messageError "Return array not exists or is not an array | '${2}'"
    return "1"
  fi
  local -n metaArrTypePropTypes="${2}"
  metaArrTypePropTypes=()
  if ! varIsArray "${3}"; then
    messageError "Return array not exists or is not an array | '${3}'"
    return "1"
  fi
  local -n metaArrTypePropNames="${3}"
  metaArrTypePropNames=()
  if ! varIsArray "${4}"; then
    messageError "Return array not exists or is not an array | '${4}'"
    return "1"
  fi
  local -n metaArrTypePropDefault="${4}"
  metaArrTypePropDefault=()
  local metaIntMaxLengthPropType="0"
  local metaIntMaxLengthPropName="0"
  if [ "${5}" != "" ] && [ "${6}" != "" ]; then
    local -n metaIntMaxLengthPropType="${5}"
    local -n metaIntMaxLengthPropName="${6}"
  fi
  local metaObjPropertiesNames="${BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES[${typeObject}]}"
  if [ "${metaObjPropertiesNames}" == "" ]; then
    return "0"
  fi
  local -a metaArrPropertiesNames=()
  IFS=';' read -r -a metaArrPropertiesNames <<< "${metaObjPropertiesNames}"
  local typePropType=""
  local typePropName=""
  local typePropDefault=""
  local -A assocPropertyMeta
  for typePropName in "${metaArrPropertiesNames[@]}"; do
    objectMetaProperty "${typeObject}" "${typePropName}" "assocPropertyMeta"; statusSet "$?"
    if [ $(statusGet) == "0" ]; then
      typePropType="${assocPropertyMeta[type]}"
      typePropName="${assocPropertyMeta[name]}"
      typePropDefault="${assocPropertyMeta[default]}"
      metaArrTypePropTypes+=("${typePropType}")
      metaArrTypePropNames+=("${typePropName}")
      metaArrTypePropDefault+=("${typePropDefault}")
      if [ "${#typePropType}" -gt "${metaIntMaxLengthPropType}" ]; then
        metaIntMaxLengthPropType="${#typePropType}"
      fi
      if [ "${#typePropName}" -gt "${metaIntMaxLengthPropName}" ]; then
        metaIntMaxLengthPropName="${#typePropName}"
      fi
    fi
  done
  return "0"
}
objectMetaTypeGetMethods() {
  local typeObject="${1}"
  if ! objectCheckTypeExists "${typeObject}"; then
    messageError "Object type is not defined | '${typeObject}'"
    return "1"
  fi
  if ! varIsArray "${2}"; then
    messageError "Return array not exists or is not an array | '${2}'"
    return "1"
  fi
  local -n metaArrTypeMethodNames="${2}"
  metaArrTypeMethodNames=()
  if ! varIsArray "${3}"; then
    messageError "Return array not exists or is not an array | '${3}'"
    return "1"
  fi
  local -n metaArrTypeMethodFunctions="${3}"
  metaArrTypeMethodFunctions=()
  local objMethodNames="${BASHKIT_MAIN_OBJECT_TYPE_METHODS[${typeObject}]}"
  if [ "${objMethodNames}" == "" ]; then
    messageError "The given object type has no methods defined | '${typeObject}'"
    return "0"
  fi
  IFS=';' read -r -a metaArrTypeMethodNames <<< "${objMethodNames}"
  local objMethodFunctions="${BASHKIT_MAIN_OBJECT_TYPE_METHODS[${typeObject}_functions]}"
  IFS=';' read -r -a metaArrTypeMethodFunctions <<< "${objMethodFunctions}"
  return "0"
}
objectMetaInstanceProperties() {
  local typeObject="${1}"
  local typeInstanceName="${2}"
  if ! objectCheckTypeExists "${typeObject}"; then
    messageError "Object type is not defined | '${typeObject}'"
    return "1"
  fi
  if ! objectCheckInstanceExists "${typeObject}" "${typeInstanceName}"; then
    messageError "Object type instance is not defined | '${typeObject}.${typeInstanceName}'"
    return "1"
  fi
  if ! varIsArray "${3}"; then
    messageError "Return array not exists or is not an array | '${3}'"
    return "1"
  fi
  local -n metaArrInstancePropNames="${3}"
  metaArrInstancePropNames=()
  if ! varIsArray "${4}"; then
    messageError "Return array not exists or is not an array | '${4}'"
    return "1"
  fi
  local -n metaArrInstancePropValues="${4}"
  metaArrInstancePropValues=()
  local metaObjPropertiesNames="${BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES[${typeObject}]}"
  if [ "${metaObjPropertiesNames}" == "" ]; then
    return "0"
  fi
  IFS=';' read -r -a metaArrInstancePropNames <<< "${metaObjPropertiesNames}"
  local typePropName=""
  for typePropName in "${metaArrInstancePropNames[@]}"; do
    metaArrInstancePropValues+=("${BASHKIT_MAIN_OBJECT_INSTANCES_VALUES[${typeObject}_${typeInstanceName}_${typePropName}]}")
  done
  return "0"
}
objectTypeCreate() {
  local typeObject="${1}"
  local typeConstructor="${2}"
  if [ "${typeObject}" == "" ]; then
    messageError "Invalid object type!"
    return "1"
  fi
  if objectCheckTypeExists "${typeObject}"; then
    messageError "Object type '${typeObject}' is already defined!"
    return "1"
  fi
  if [[ ! "${typeObject}" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
    messageError "Invalid object type name | '${typeObject}'"
    return "1"
  fi
  if [ "${typeConstructor}" != "" ] && ! varIsFunction "${typeConstructor}" ]; then
    messageError "Invalid constructor | '${typeConstructor}'; expected function."
  fi
  BASHKIT_MAIN_OBJECT_TYPES["${typeObject}"]="-"
  BASHKIT_MAIN_OBJECT_TYPE_METHODS["${typeObject}"]=""
  BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES["${typeObject}"]=""
  BASHKIT_MAIN_OBJECT_TYPE_CONSTRUCTORS["${typeObject}"]="${typeConstructor}"
  objectTypeCreateStart "${typeObject}"
  eval "${typeObject}() { objectInstanceAccess \"${typeObject}\" \"\$@\"; }"
}
objectTypeCreateStart() {
  local typeObject="${1}"
  if ! objectCheckTypeExists "${typeObject}"; then
    return "1"
  fi
  BASHKIT_MAIN_OBJECT_TYPES["${typeObject}"]="definitionMode"
}
objectTypeCreateEnd() {
  local typeObject="${1}"
  if ! objectCheckTypeExists "${typeObject}"; then
    return "1"
  fi
  BASHKIT_MAIN_OBJECT_TYPES["${typeObject}"]="-"
}
objectTypeSetProperty() {
  local typeObject="${1}"
  local typePropType="${2}"
  local typePropName="${3}"
  local typePropDefault="${4}"
  local typePropSetFn="${5}"
  local typePropGetFn="${6}"
  if ! objectCheckTypeExists "${typeObject}"; then
    messageError "Object type is not defined | '${typeObject}'"
    return "1"
  fi
  if ! objectCheckTypeInDefinitionMode "${typeObject}"; then
    messageError "Object type is not in definition mode | '${typeObject}'"
    return "1"
  fi
  if [[ ! " ${BASHKIT_MAIN_OBJECT_ALLOWED_PROPERTIES_TYPES[*]} " =~ " ${typePropType} " ]]; then
    messageError "Invalid property type | '${typePropType}'"
    return "1"
  fi
  if [ "${typePropName}" == "" ] || [[ ! "${typePropName}" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
    messageError "Invalid property name | '${typePropName}'"
    return "1"
  fi
  if objectCheckTypePropertyExists "${typeObject}" "${typePropName}"; then
    messageError "Property already exists for the object | '${typeObject}.${typePropName}'"
    return "1"
  fi
  if [ "${typePropDefault}" != "" ]; then
    if [ "${typePropType}" == "array" ] || [ "${typePropType}" == "assoc" ]; then 
      messageError "Invalid given default value | '${typeObject}.${typePropName}=${typePropDefault}'; Type '"${typePropType}"' not accepts default value."
      return "1"
    fi
    if ! objectCheckPropertyValue "${typePropType}" "${typePropDefault}"; then
      messageError "Invalid given default value | '${typeObject}.${typePropName}=${typePropDefault}'; expected a valid '${typeObject}'"
      return "1"
    fi
  fi
  if [ "${typePropSetFn}" != "" ] && ! varIsFunction "${typePropSetFn}"; then
    messageError "Invalid set method (not a function) | '${typePropSetFn}'"
    return "1"
  fi
  if [ "${typePropGetFn}" != "" ] && ! varIsFunction "${typePropGetFn}"; then
    messageError "Invalid get method (not a function) | '${typePropGetFn}'"
    return "1"
  fi
  local propertyRegName="${typeObject}_${typePropName}"
  BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES["${typeObject}"]+="${typePropName};"
  BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES["${propertyRegName}"]="-"
  BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES["${propertyRegName}_type"]="${typePropType}"
  BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES["${propertyRegName}_name"]="${typePropName}"
  BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES["${propertyRegName}_default"]="${typePropDefault}"
  BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES["${propertyRegName}_set"]="${typePropSetFn}"
  BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES["${propertyRegName}_get"]="${typePropGetFn}"
  return "0"
}
objectTypeSetMethod() {
  local typeObject="${1}"
  local typeMethodName="${2}"
  local typeMethodFunction="${3}"
  if ! objectCheckTypeExists "${typeObject}"; then
    messageError "Object type is not defined | '${typeObject}'"
    return "1"
  fi
  if ! objectCheckTypeInDefinitionMode "${typeObject}"; then
    messageError "Object type is not in definition mode | '${typeObject}'"
    return "1"
  fi
  if [ "${typeMethodName}" == "" ] || [[ ! "${typeMethodName}" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
    messageError "Invalid method name | '${typeMethodName}'"
    return "1"
  fi
  if objectCheckTypeMethodExists "${typeObject}" "${typeMethodName}"; then
    messageError "Method already exists for the object | '${typeObject}.${typeMethodName}()'"
    return "1"
  fi
  if ! varIsFunction "${typeMethodFunction}"; then
    messageError "Invalid function | '${typeMethodFunction}'"
    return "1"
  fi
  local regTypeMethodName="${typeObject}_${typeMethodName}"
  BASHKIT_MAIN_OBJECT_TYPE_METHODS["${typeObject}"]+="${typeMethodName};"
  BASHKIT_MAIN_OBJECT_TYPE_METHODS["${typeObject}_functions"]+="${typeMethodFunction};"
  BASHKIT_MAIN_OBJECT_TYPE_METHODS["${regTypeMethodName}"]="-"
  BASHKIT_MAIN_OBJECT_TYPE_METHODS["${regTypeMethodName}_name"]="${typeMethodName}"
  BASHKIT_MAIN_OBJECT_TYPE_METHODS["${regTypeMethodName}_function"]="${typeMethodFunction}"
  return "0"
}
objectTypeDump() {
  local typeObject="${1}"
  if ! objectCheckTypeExists "${typeObject}"; then
    messageError "Object type is not defined | '${typeObject}'"
    return "1"
  fi
  local objDefMode=$(objectCheckTypeInDefinitionMode "${typeObject}" && echo "true" || echo "false")
  local -a dumpArrTypePropTypes=()
  local -a dumpArrTypePropNames=()
  local -a dumpArrTypePropDefault=()
  local dumpIntMaxLengthPropType="0"
  local dumpIntMaxLengthPropName="0"
  objectMetaTypeGetProperties "${typeObject}" "dumpArrTypePropTypes" "dumpArrTypePropNames" "dumpArrTypePropDefault" "dumpIntMaxLengthPropType" "dumpIntMaxLengthPropName"
  ((dumpIntMaxLengthPropType = dumpIntMaxLengthPropType + 2))
  local -a dumpArrTypeMethodNames=()
  local -a dumpArrTypeMethodFunctions=()
  objectMetaTypeGetMethods "${typeObject}" "dumpArrTypeMethodNames" "dumpArrTypeMethodFunctions"
  echo "# Dump object type"
  echo "## Type '${typeObject}'"
  echo "   - Def mode : ${objDefMode}"
  echo ""
  if [ "${#dumpArrTypePropTypes[@]}" -gt "0" ]; then
    echo "## Properties :"
    local it="" 
    local propertyType=""
    local propertyName=""
    local propertyDefault=""
    for it in "${!dumpArrTypePropTypes[@]}"; do
      propertyType=$(stringPaddingL "[${dumpArrTypePropTypes[${it}]}]" " " "${dumpIntMaxLengthPropType}")
      propertyName=$(stringPaddingR "${dumpArrTypePropNames[${it}]}" " " "${dumpIntMaxLengthPropName}")
      propertyDefault="${dumpArrTypePropDefault[${it}]}"
      echo "   ${propertyType} ${propertyName} = '${propertyDefault}'"
    done
  fi
  if [ "${#dumpArrTypeMethodNames[@]}" -gt "0" ]; then
    echo ""
    echo "## Methods :"
    local it="" 
    local typeMethodName=""
    local typeMethodFunction=""
    for it in "${!dumpArrTypeMethodNames[@]}"; do
      typeMethodName="${dumpArrTypeMethodNames[${it}]}"
      typeMethodFunction="${dumpArrTypeMethodFunctions[${it}]}"
      echo "   - ${typeMethodName} -> ${typeMethodFunction}()"
    done
  fi
  return "0"
}
objectInstanceNew() {
  local typeObject="${1}"
  local typeInstanceName="${2}"
  if ! objectCheckTypeExists "${typeObject}"; then
    messageError "Object type is not defined | '${typeObject}'"
    return "1"
  fi
  if [ "${typeInstanceName}" == "" ] ||  [[ ! "${typeInstanceName}" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
    messageError "Invalid instance name | '${typeInstanceName}'"
    return "1"
  fi
  if objectCheckInstanceExists "${typeObject}" "${typeInstanceName}"; then
    messageError "Instance alread exists | '${typeObject}.${typeInstanceName}'"
    return "1"
  fi
  local regTypeInstanceName="${typeObject}_${typeInstanceName}"
  BASHKIT_MAIN_OBJECT_INSTANCES["${typeObject}"]+="${typeInstanceName};"
  BASHKIT_MAIN_OBJECT_INSTANCES["${regTypeInstanceName}"]="-"
  local -a arrTypePropTypes=()
  local -a arrTypePropNames=()
  local -a arrTypePropDefault=()
  local intMaxLengthPropType="0"
  local intMaxLengthPropName="0"
  objectMetaTypeGetProperties "${typeObject}" "arrTypePropTypes" "arrTypePropNames" "arrTypePropDefault" "intMaxLengthPropType" "intMaxLengthPropName"
  local it=""
  local typePropType=""
  local typePropName=""
  local typePropDefault=""
  local regTypeInstancePropName=""
  for it in "${!arrTypePropNames[@]}"; do
    typePropType="${arrTypePropTypes[${it}]}"
    typePropName="${arrTypePropNames[${it}]}"
    typePropDefault="${arrTypePropDefault[${it}]}"
    regTypeInstancePropName="${regTypeInstanceName}_${typePropName}"
    if [ "${typePropType}" == "array" ]; then
      typePropDefault="${regTypeInstancePropName}_array"
      declare -ga "${typePropDefault}"
    elif [ "${typePropType}" == "assoc" ]; then
      typePropDefault="${regTypeInstancePropName}_assoc"
      declare -gA "${typePropDefault}"
    fi
    BASHKIT_MAIN_OBJECT_INSTANCES_VALUES["${regTypeInstancePropName}"]="${typePropDefault}"
  done
  local -a arrTypeMethodNames=()
  local -a arrTypeMethodFunctions=()
  objectMetaTypeGetMethods "${typeObject}" "arrTypeMethodNames" "arrTypeMethodFunctions"
  local it=""
  local typeMethodName=""
  local typeMethodFunction=""
  local regTypeInstanceMethodName=""
  for it in "${!arrTypeMethodNames[@]}"; do
    typeMethodName="${arrTypeMethodNames[${it}]}"
    typeMethodFunction="${arrTypeMethodFunctions[${it}]}"
    regTypeInstanceMethodName="${regTypeInstanceName}_${typeMethodName}"
    BASHKIT_MAIN_OBJECT_INSTANCES_VALUES["${regTypeInstanceMethodName}"]="${typeMethodFunction}"
  done
  local typeInstanceContructor="${BASHKIT_MAIN_OBJECT_TYPE_CONSTRUCTORS["${typeObject}"]}"
  if [ "${typeInstanceContructor}" != "" ]; then
    local -A objectInstanceExecArgs
    objectInstanceFillInternalMethodMainArg "${typeObject}" "${typeInstanceName}" "" "objectInstanceExecArgs"
    $typeInstanceContructor  "objectInstanceExecArgs" "$@"
  fi
  return "0"
}
objectInstanceAccess() {
  local typeObject="${1}"
  local typeInstanceName="${2}"
  local typeInstanceAction="${3,,}"
  local typeInstanceMemberName="${4}"
  if ! objectCheckTypeExists "${typeObject}"; then
    messageError "Object type is not defined | '${typeObject}'"
    return "1"
  fi
  if ! objectCheckInstanceExists "${typeObject}" "${typeInstanceName}"; then
    messageError "Object type instance is not defined | '${typeObject}.${typeInstanceName}'"
    return "1"
  fi
  case "${typeInstanceAction}" in
    "get" | "set")
      if ! objectCheckTypePropertyExists "${typeObject}" "${typeInstanceMemberName}"; then
        messageError "Object type property not exists | '${typeObject}.${typeInstanceMemberName}'"
        return "1"
      fi
      ;;
    "exec")
      if ! objectCheckTypeMethodExists "${typeObject}" "${typeInstanceMemberName}"; then
        messageError "Object type method not exists | '${typeObject}.${typeInstanceMemberName}'"
        return "1"
      fi
      ;;
    *)
      messageError "Invalid action | '${typeInstanceAction}'; expected 'get', 'set' or 'exec'"
      return "1"
      ;;
  esac
  local regTypeInstanceMemberName="${typeObject}_${typeInstanceName}_${typeInstanceMemberName}"
  local currentInstanceMemberValue="${BASHKIT_MAIN_OBJECT_INSTANCES_VALUES[${regTypeInstanceMemberName}]}"
  local currentPropType="${BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES["${typeObject}_${typeInstanceMemberName}_type"]}"
  case "${typeInstanceAction}" in
    "get")
      local currentInstanceMemberGetFn="${BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES["${typeObject}_${typeInstanceMemberName}_get"]}"
      if [ "${currentInstanceMemberGetFn}" != "" ]; then
        typeInstanceAction="exec"
        currentInstanceMemberValue="${currentInstanceMemberGetFn}"
      else
        if [ "${currentPropType}" == "array" ] || [ "${currentPropType}" == "assoc" ]; then
          local newPropArrayGetKey="${5}"
          local -n tmpArr="${currentInstanceMemberValue}"
          if [[ ! -v tmpArr["${newPropArrayGetKey}"] ]]; then
            messageError "Invalid ${currentPropType} key | '${typeInstanceMemberName}.${newPropArrayGetKey}'"
            return "1"
          fi
          echo "${tmpArr[${newPropArrayGetKey}]}"
          return "0"
        fi
        echo "${currentInstanceMemberValue}"
        return "0"
      fi
      ;;
    "set")
      currentInstanceMemberSetFn="${BASHKIT_MAIN_OBJECT_TYPE_PROPERTIES["${typeObject}_${typeInstanceMemberName}_set"]}"
      if [ "${currentInstanceMemberSetFn}" != "" ]; then
        typeInstanceAction="exec"
        currentInstanceMemberValue="${currentInstanceMemberSetFn}"
      else
        if [ "${currentPropType}" == "array" ]; then
          local newPropArraySetMode="${5}"
          local -n tmpArr="${currentInstanceMemberValue}"
          case "${newPropArraySetMode}" in
            "append")
              local newPropArraySetValue="${6}"
              tmpArr+=("${newPropArraySetValue}")
              ;;
            "set")
              local newPropArraySetIndex="${6}"
              local newPropArraySetValue="${7}"
              tmpArr["${newPropArraySetIndex}"]="${newPropArraySetValue}"
              ;;
            "unset")
              local newPropArraySetIndex="${6}"
              unset tmpArr["${newPropArraySetIndex}"]
              ;;
            "clear")
              tmpArr=()
              ;;
            *)
              messageError "Invalid array mode | '${newPropArraySetMode}'; expected 'append', 'set' or 'unset'"
              ;;
          esac
          return "0"
        fi
        if [ "${currentPropType}" == "assoc" ]; then
          local newPropAssocSetMode="${5}"
          local -n tmpAssoc="${currentInstanceMemberValue}"
          case "${newPropAssocSetMode}" in
            "set")
              local newPropArraySetKey="${6}"
              local newPropArraySetValue="${7}"
              tmpAssoc["${newPropArraySetKey}"]="${newPropArraySetValue}"
              ;;
            "unset")
              local newPropArraySetKey="${6}"
              unset tmpAssoc["${newPropArraySetKey}"]
              ;;
            "clear")
              local it=""
              for it in "${!tmpAssoc[@]}"; do
                unset tmpAssoc["${it}"]
              done
              ;;
            *)
              messageError "Invalid assoc mode | '${newPropAssocSetMode}'; expected 'set', 'unset' or 'clear'"
              ;;
          esac
          return "0"
        fi
        local newPropValue="${5}"
        if ! objectCheckPropertyValue "${currentPropType}" "${newPropValue}"; then
          return "1"
        fi
        BASHKIT_MAIN_OBJECT_INSTANCES_VALUES["${regTypeInstanceMemberName}"]="${newPropValue}"
        return "0"
      fi
    ;;
  esac
  if [ ${typeInstanceAction} == "exec" ]; then
    shift; shift; shift; shift; 
    local -A objectInstanceExecArgs
    objectInstanceFillInternalMethodMainArg "${typeObject}" "${typeInstanceName}" "${typeInstanceMemberName}" "objectInstanceExecArgs"
    if [ "${currentPropType}" == "array" ] || [ "${currentPropType}" == "assoc" ]; then
      objectInstanceExecArgs["_runtimeRegTypeInstanceMemberName"]="${typeObject}_${typeInstanceName}_${typeInstanceMemberName}_${currentPropType}"
    fi
    $currentInstanceMemberValue  "objectInstanceExecArgs" "$@"
  fi
}
objectInstanceFillInternalMethodMainArg() {
  local typeObject="${1}"
  local typeInstanceName="${2}"
  local typeInstanceMemberName="${3}"
  local strTmpAssocName="${4}"
  if ! objectCheckTypeExists "${typeObject}"; then
    messageError "Object type is not defined | '${typeObject}'"
    return "1"
  fi
  if ! objectCheckInstanceExists "${typeObject}" "${typeInstanceName}"; then
    messageError "Object type instance is not defined | '${typeObject}.${typeInstanceName}'"
    return "1"
  fi
  if ! varIsAssoc "${strTmpAssocName}"; then
    messageError "Assoc not exists or is not an assoc array | '${strTmpAssocName}'"
    return "1"
  fi
  local -n tmpAssocArray="${strTmpAssocName}"
  tmpAssocArray["_runtimeTypeObject"]="${typeObject}"
  tmpAssocArray["_runtimeTypeInstanceName"]="${typeInstanceName}"
  tmpAssocArray["_runtimeTypeInstanceMemberName"]="${typeInstanceMemberName}"
  tmpAssocArray["_runtimeRegTypeInstanceMemberName"]="${typeObject}_${typeInstanceName}_${typeInstanceMemberName}"
  tmpAssocArray["_runtimeObjectInstanceExecArgs"]="${strTmpAssocName}"
  local -a arrTypePropNames=()
  local -a arrTypePropValues=()
  objectMetaInstanceProperties "${typeObject}" "${typeInstanceName}" "arrTypePropNames" "arrTypePropValues"
  local it=""
  local typePropName=""
  local typePropValue=""
  local regTypeInstancePropName=""
  for it in "${!arrTypePropNames[@]}"; do
    typePropName="${arrTypePropNames[${it}]}"
    typePropValue="${arrTypePropValues[${it}]}"
    tmpAssocArray["${typePropName}"]="${typePropValue}"
  done
  return "0"
}