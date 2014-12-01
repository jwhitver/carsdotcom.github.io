---
published: false
layout: post
title:  "Mutation Testing – 100% code coverage isn’t good enough"
date:   2014-12-01   11:32:42

---
*by Jacob Whitver, Lead Developer, Shared Services*

Unit testing has many benefits to your day to day coding.  Unit tests document assumptions that were made when the code was written, they help you make sure that your edits haven't broken the code, and if using TDD – unit tests help write cleaner code.

Code coverage is a metric commonly used to gauge unit test quality.  Code coverage is reported in Sonar as a key metric of code quality.  While code coverage is a good metric – it might fall short in reporting actual unit test effectiveness when dealing with complex methods.

In this blog post I will present Mutation Testing as a way to increase your unit test effectiveness and show you how to install and run PIT against your unit tests.  This allows for your unit tests to have a higher probability of catching issues introduced during your day to day development or refactoring.  This also helps you to write better unit tests which produce better quality code.

###Code Coverage
Code coverage reports how many lines of code or branches of your code were executed during your unit tests.  If we look at a simple example of code with two unit tests we can see that 100% of our code is covered.

I created a simple example code that simulates a service/manager class using a DAO layer.  If the item returned from the DAO layer has a certain property, then another method is called that produces a side effect.

I wrote unit tests for this example and used EclEmma to verify code coverage.  I stopped testing when I reached 100% code coverage.

![Code Coverage][CodeCoverage]

The issue with relying on code coverage alone is that just because a line of code was hit during the unit test execution, it doesn't necessarily mean that all lines were verified as being executed during the test.  When a method has side effects, a unit test verifying the output of a method does not verify everything that was executed during a test.  It would be possible for a developer to modify a side effect which could lead to regressions in the code base.  This is one reason many people promote the idea of functional programming which outlaws side effects from methods.  Functional programming has historically been associated with the more academic languages (Scala, Haskell, Lisp, Clojure) but is possible to do in Java (but is somewhat cumbersome).

###Enter PIT
PIT is a unit test runner that attempts to locate these unverified lines of code in your unit testing.  PIT first requires that your unit test suite is reporting green – all tests pass.  PIT then takes your compiled byte code and starts modifying it in very specific ways (returning null from a method, changing the sign of an integer, changing a Boolean condition, etc).  These modifications are called mutations and are meant to simulate how your code can be modified by a developer during their day to day development.  After modifying the byte code, PIT then re-executes your unit tests.  If the modification to your code does not produce a failing test, the mutant is said to have survived.

###Installing PIT
Installing PIT into your STS/Eclipse project is done by using the following update site:

http://eclipse.pitest.org/release

Follow normal plugin installation.

![Installing PIT][InstallingPIT]

###Running PIT
To run PIT right click on your test source directory and choose Run As…-> PIT Mutation Test

![Running PIT][RunningPIT]

![PIT Output 1][PITOutput1]
![PIT Output 2][PITOutput2]
![PIT Output 3][PITOutput3]


###Kill the Mutants
The goal should now be to kill the surviving mutants.  To kill the mutants you will need to write tests to verify the lines PIT reports a survived mutant.  This is much harder to do in legacy code where there are many branches in a method, or side effect happen in multiple places.  In newer code you should be limiting your method size and side effects that take place in a method. 

In the case of my simple example, I had to add one test to check for id = 25.  Once this one test was added I now have 100% code coverage and 100% mutation coverage.

![All Mutants Killed][allMutantsKilled]

As you work with PIT and see how unit tests interact during mutation testing you will find you start covering these conditions during your normal testing.  Mutation testing does get easier the more you use it.

###Mutation Testing and TDD
When you start looking at TDD it requires that you write your tests up front.  TDD has the benefit of allowing you to test your interface and integration before writing your implementation.  It also allows you to write code that is easily tested since you are writing your tests first.

Mutation testing requires a green suite, so how would you use this with TDD?   Mutation testing would happen at the end to catch the edge cases and boundary conditions of the code.  Once your implementation is complete and your test suite is reporting green, run PIT against your tests and verify all mutants have been killed.  This will lead to a stronger test suite and better code coverage for you projects.


[CodeCoverage]: https://raw.githubusercontent.com/carsdotcom/carsdotcom.github.io/master/images/CodeCoverage.png
[InstallingPIT]: https://raw.githubusercontent.com/carsdotcom/carsdotcom.github.io/master/images/InstallingPIT.png
[RunningPIT]: https://raw.githubusercontent.com/carsdotcom/carsdotcom.github.io/master/images/RunningPIT.png
[PITOutput1]: https://raw.githubusercontent.com/carsdotcom/carsdotcom.github.io/master/images/PITOutput1.png
[PITOutput2]: https://raw.githubusercontent.com/carsdotcom/carsdotcom.github.io/master/images/PITOutput2.png
[PITOutput3]: https://raw.githubusercontent.com/carsdotcom/carsdotcom.github.io/master/images/PITOutput3.png
[allMutantsKilled]: https://raw.githubusercontent.com/carsdotcom/carsdotcom.github.io/master/images/allMutantsKilled.png
