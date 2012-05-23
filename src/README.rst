======
README
======

``meta`` is a demoscene framework written by Dimitri 'skypers' Sabadie. It is intented to be used only by skypers in the demoscene
world, but if you want to use it in another kind of project, you can do it under the GPL copying.

``meta`` a is metaprogramming-oriented framework, which means it is highly flexible. You can customize many of the ``meta`` parts in order to
optimize your application. Now let's get started!


I - Downloading, installing...
------------------------------

The quick way to get the latest stable version of ``meta`` is through Git. Just clone the bellow git repository :
    git@bitbucket.org:skypers/meta.git
Then, you have to compile it on your own. ``meta`` is written in D2, you can use any D2 compilers to build it, but you'll need some dependencies
to be installed:
    - DerelictGLFW3
    - DerelictGL3
That's all! [ TO CONTINUE... ]


II - Preparing your project
---------------------------

Because ``meta`` is a framework after all, linking against ``meta`` is performed using embedded tools. [ TO CONTINUE... ]


III - Architecture
------------------

The architecture of ``meta`` is funny. It's something like MVC, but it's not. Basically, you have the renderer and its objects, the scene and
its objects. Actually, there's several packages in ``meta``:

utils
    This package is for utils objects, such as mixins template (OneInstance, Singleton, ...), logger, math, traits, memory...
views
    render
        This package is for render objects and is intented to be used when you want to render something.
    user
        This package is for user interactivity
wrappers
    This package encapsulates all wrappers. The most useful wrapper is for sure the OpenGL one (which is OOP, of course)
model
    This package regroups models. Models are part of MVC architecture. You can find there classical objects like mesh, light, terrain,
    scene entity, scene instance, and so on...
controller
    This package is somehow tricky. For instance it's not used, but soon it will be the place for controllers, providing entry points to your
    application and logic implementation.


IV - "Hello, world!"
--------------------

Let's write our first application. ``meta`` is designed to be easy to use. Before starting coding, some details about ``meta``.
``meta`` is kinda low-level. The first thing you may want to do is opening a window, set some renderer's properties such as the clear color or
enabling some caps, and so on... That stuff is performed using the ``device`` class.

  1) ``device``
  -------------

  ``device`` 
