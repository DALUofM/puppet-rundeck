require 'spec_helper'

describe 'rundeck::config::project', :type => :define do
  context 'supported operating systems' do
    ['Debian','RedHat'].each do |osfamily|
      describe "rundeck::config::project definition without any parameters on #{osfamily}" do
        projects_dir = '/var/rundeck/projects'

        let(:title) { 'test' }
        let(:params) {{
          :projects_dir => projects_dir,
          :file_copier_provider => 'jsch-scp',
          :resource_sources => {},
          :ssh_keypath => '/var/lib/rundeck/.ssh/id_rsa',
          :node_executor_provider => 'jsch-ssh',
        }}

        let(:facts) {{
          :osfamily => osfamily
        }}

        it { should contain_file("#{projects_dir}/test/var").with(
          'ensure' => 'directory'
        ) }

        it { should contain_file("#{projects_dir}/test/etc").with(
          'ensure' => 'directory'
        ) }

        it { should contain_file("#{projects_dir}/test/etc/project.properties") }

        project_details = {
          'project.name' => 'test',
          'project.ssh-authentication' => 'privateKey',
          'project.ssh-keypath' => '/var/lib/rundeck/.ssh/id_rsa',
          'service.NodeExecutor.default.provider' => 'jsch-ssh',
          'service.FileCopier.default.provider' => 'jsch-scp'
        }

        project_details.each do |key,value|
          it { should contain_ini_setting("test::#{key}").with(
            'path'    => '/var/rundeck/projects/test/etc/project.properties',
            'setting' => key,
            'value'   => value
          ) }
        end
      end
    end
  end
end
