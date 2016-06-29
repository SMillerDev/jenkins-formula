{% from "jenkins/map.jinja" import jenkins with context %}
jenkins:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/sysconfig/jenkins
      
jenkins_config:
  {% for key, config in jenkins.config.items() %}
  file.replace:
    - name: /etc/sysconfig/jenkins
    - count: 1
    - pattern: '(\#?{{key|upper}}\=\".*\")'
    - repl: '{{ key|upper }}="{{ config }}"'
  {% endfor %}