{%- from "snmp/map.jinja" import snmp with context -%}

{%- set agent = salt['pillar.get']('snmp:snmpd:agent', {}) -%}
{%- set access = salt['pillar.get']('snmp:snmpd:access', {}) -%}

snmpd_package:
  pkg.installed:
    - name: {{ snmp.snmpd }}

snmpd_configuration:
  file.managed:
    - name: /etc/snmp/snmpd.conf
    - user: root
    - group: root
    - mode: 640
    - template: jinja
    - source: salt://snmp/files/snmpd.conf
    - context:
        agent: {{ agent }}
        access: {{ access }}

snmpd_service:
  service.running:
    - name: snmpd
    - watch:
      - file: snmpd_configuration
