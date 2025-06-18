local utils = require("new-file-template.utils")

local function base_template(relative_path, filename)
  return [[
- name: Create directory
  file:
    path:     '{{ item }}'
    state:    directory
    owner:    '{{ n8n_user }}'
    group:    '{{ n8n_group }}'
  with_items:
    - '{{ n8n_service_path }}'
    - '{{ n8n_service_conf }}'
    - '{{ n8n_app_cont_data }}'
    - '{{ n8n_db_data_vol }}'
    - '{{ n8n_db_backup_vol }}'

- name: Create compose file
  template:
    src:      'docker-compose.yml.j2'
    dest:     '{{ n8n_compose_file }}'
    owner:    '{{ n8n_user }}'
    group:    '{{ n8n_group }}'
    mode:     0640

- name: Create configuration file
  template:
    src:      '{{ item.src }}'
    dest:     '{{ n8n_service_conf }}/{{ item.dest }}'
    owner:    '{{ n8n_user }}'
    group:    '{{ n8n_group }}'
    mode: 0640
  with_items:
    - { src: 'db.env.j2',       dest: 'db.env' }
    - { src: 'n8n.env.j2',      dest: 'n8n.env' }

- name: Create containers
  community.docker.docker_compose_v2:
    project_src:    '{{ n8n_service_path }}'
    state:          '{{ compose_state }}'
    recreate:       '{{ compose_recreate }}'
  ]]
end

--- @param opts table
---   A table containing the following fields:
---   - `full_path` (string): The full path of the new file, e.g., "lua/new-file-template/templates/init.lua".
---   - `relative_path` (string): The relative path of the new file, e.g., "lua/new-file-template/templates/init.lua".
---   - `filename` (string): The filename of the new file, e.g., "init.lua".
return function(opts)
  local template = {
    { pattern = ".*", content = base_template },
  }

	return utils.find_entry(template, opts)
end
