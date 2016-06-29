jenkins
=======

Available states
================

.. contents::
    :local:

``jenkins``
-----------

Install jenkins from the source package repositories and start it up.

``jenkins.config``
-----------

Set jenkins config from the pillar file

``jenkins.plugins``
-----------

Set jenkins plugins from the pillar file

``jenkins.jobs``
-----------

Set jenkins jobs from the pillar file

Pillar customizations:
==========================

.. code-block:: yaml

    jenkins:
      port: 80
      home: /usr/local/jenkins
      user: jenkins
      group: www-data