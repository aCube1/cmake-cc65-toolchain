include_guard()

set(CMAKE_SYSTEM_NAME Generic)

find_program(CMAKE_AR ar65 DOC "cc65 archiver")
find_program(CMAKE_LINKER ld65 DOC "cc65 linker")

# Determine C compiler
find_program(CMAKE_C_COMPILER cl65 DOC "cc65 C compiler")
if(CMAKE_C_COMPILER)
	set(CMAKE_C_COMPILER_ID CC65 CACHE PATH "C compiler ID")

	execute_process(
		COMMAND ${CMAKE_C_COMPILER} --version
		OUTPUT_VARIABLE _OUTPUT1
		ERROR_VARIABLE _OUTPUT2
	)

	if("${_OUTPUT1};${_OUTPUT2}" MATCHES ".*cc65 V([^\n]*)-.*")
		set(
			CMAKE_C_COMPILER_VERSION
			"${CMAKE_MATCH_1}" CACHE PATH "C compiler version"
		)
	endif()

	unset(_OUTPUT1)
	unset(_OUTPUT2)

	set(CMAKE_C_ABI_COMPILED YES)
	set(CMAKE_C_COMPILER_WORKS YES)
endif()

# Determine ASM compiler
find_program(CMAKE_ASM_COMPILER ca65 DOC "cc65 assembler")
if(CMAKE_ASM_COMPILER)
	set(CMAKE_ASM_COMPILER_ID CA65 CACHE PATH "cc65 assembler ID")

	execute_process(
		COMMAND ${CMAKE_ASM_COMPILER} --version
		OUTPUT_VARIABLE _OUTPUT1
		ERROR_VARIABLE _OUTPUT2
	)

	if("${_OUTPUT1};${_OUTPUT2}" MATCHES ".*ca65 V([^\n]*)-.*")
		set(
			CMAKE_ASM_COMPILER_VERSION
			"${CMAKE_MATCH_1}" CACHE PATH "cc65 assembler version"
		)
	endif()

	unset(_OUTPUT1)
	unset(_OUTPUT2)
endif()

macro(_compiler_cc65 lang)
	set(CMAKE_${lang}_COMPILER_AR ${CMAKE_AR} CACHE PATH "${lang} archiver" FORCE)
	set(CMAKE_${lang}_RANLIB "" CACHE FILEPATH "")

	set(CMAKE_${lang}_COMPILER_ID_RUN YES)
	set(CMAKE_${lang}_COMPILER_ID_WORKS YES)
	set(CMAKE_${lang}_COMPILER_ID_FORCED YES)

	set(CMAKE_${lang}_DEFINE_FLAG "-D ")
	set(CMAKE_${lang}_VERBOSE_FLAG "-v" )
	set(CMAKE_${lang}_FLAGS_DEBUG_INIT "-g -D_DEBUG=1")
	set(CMAKE_DEPFILE_FLAGS_${lang} "--create-dep <DEP_FILE>")
	set(CMAKE_INCLUDE_FLAG_${lang} "-I ")
	set(CMAKE_${lang}_LINK_LIBRARY_FLAG "")
endmacro()

_compiler_cc65(C)
_compiler_cc65(ASM)

set(CMAKE_ASM_SOURCE_FILE_EXTENSIONS s;S;asm)

set(CMAKE_C90_STANDARD_COMPILE_OPTION "--standard c89")
set(CMAKE_C99_STANDARD_COMPILE_OPTION "--standard c99")

set(
	CMAKE_C_CREATE_ASSEMBLY_SOURCE
	"<CMAKE_C_COMPILER> <DEFINES> <INCLUDES> <FLAGS> -o <OBJECT> <SOURCE>"
)

set(
	CMAKE_C_CREATE_PREPROCESSED_SOURCE
	"<CMAKE_C_COMPILER> <DEFINES> <INCLUDES> <FLAGS> -E -o <PREPROCESSED_SOURCE> <SOURCE>"
)

set(
	CMAKE_C_COMPILE_OBJECT
	"<CMAKE_C_COMPILER> <DEFINES> <INCLUDES> <FLAGS> -c -o <OBJECT> <SOURCE>"
)

set(
	CMAKE_ASM_COMPILE_OBJECT
	"<CMAKE_ASM_COMPILER> <DEFINES> <INCLUDES> <FLAGS> -o <OBJECT> <SOURCE>"
)

set(
	CMAKE_C_LINK_EXECUTABLE
	"<CMAKE_LINKER> <LINK_FLAGS> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>"
)
