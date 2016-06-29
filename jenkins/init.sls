{% from "jenkins/map.jinja" import jenkins with context %}

jenkins_group_user_home:
  group.present:
    - name: {{ jenkins.group }}
    - system: True
  user.present:
    - name: {{ jenkins.user }}
    - groups:
      - {{ jenkins.group }}
    - system: True
    - home: {{ jenkins.home }}
    - require:
      - group: jenkins_group_user_home
  file.directory:
    - name: {{ jenkins.home }}
    - user: {{ jenkins.user }}
    - group: {{ jenkins.group }}
    - require:
      - user: jenkins_group_user_home
      - group: jenkins_group_user_home


jenkins_install:
  {% if grains['os_family'] in ['RedHat', 'Debian'] %}
    {% if jenkins['rc-release'] %}
      {% set appendix =  '-rc'%}
    {% else %}
      {% set appendix = '' %}
    {% endif %}
    {% set os_string = grains['os_family'] %}
  pkgrepo.managed:
    - humanname: Jenkins upstream package repository
    {% if os_string == 'RedHat'%}
    - baseurl: http://pkg.jenkins-ci.org/{{ os_string|lower }}{{ appendix }}/
    - gpgkey: http://pkg.jenkins-ci.org/{{ os_string|lower }}{{ appendix }}/jenkins-ci.org.key
    {% elif os_string == 'Debian' %}
    - file: {{jenkins.deb_apt_source}}
    - name: deb http://pkg.jenkins-ci.org/{{ os_string|lower }}{{ appendix }} binary/
    - key_url: http://pkg.jenkins-ci.org/{{ os_string|lower }}{{ appendix }}/jenkins-ci.org.key
    {% endif %}
    - require_in:
      - pkg: jenkins
  {% endif %}
  pkg.installed:
    - pkgs: {{ jenkins.pkgs|json }}
  service.running:
    - enable: True
    - watch:
      - pkg: jenkins
