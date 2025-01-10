# DependencyManager.cmake

CMake module for specifying (complex) dependency relationships without the usual boilerplate.


## Motivation

In principle, dependency management in CMake is relatively straight-forward. Add a `find_package` call to locate the dependency and then use
`target_link_libraries` and friends to link the resolved dependency to your own target. But what if the package in question uses different names or
even only different capitalization in different versions and/or on different platforms. Or what if we have an optional dependency and if it is (not)
found we want to add one or more compile definitions (aka: macros) to our target to e.g. selectively enable or disable certain functionality? How
about the situation where `find_package` doesn't find the dependency but `pkg-config` is able to locate the dependency for us?

Of course, all of these issues can be and routinely are solved in various projects. However, supporting these kinds of scenarios tends to involve a
fair amount of boilerplate code that can quickly have a negative impact on overall readability of the entire CMake project.

In order to remove the need to write this boilerplate time and time again, this module tries to serve as a versatile implementation of all of this
boilerplate to be reused in other projects.

