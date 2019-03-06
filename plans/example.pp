plan napalm::example(
  TargetSpec $nodes,
  String $user,
  String $password,
  String $vendor,
  String $hostname,
  Boolean $debug=false,
  String $config_file='napalm/banner.cfg',
  String $validation_file='napalm/validate.yaml'
  ) {
  run_task(napalm::install_dependencies, $nodes,'Installing dependencies...')
  $r1 = run_task(napalm::call, $nodes,'Getting facts...',
  'user'     => $user,
  'password' => $password,
  'vendor'   => $vendor,
  'hostname' => $hostname,
  'debug'    => $debug,
  'method'   => 'get_facts')
  $r1.each |$result| {
    $node = $result.target.name
    if $result.ok {
      notice("${result.message}")
    } else {
      notice("${node} errored with a message: ${result.error.message}")
    }
  }

  upload_file($config_file, '/tmp/banner.cfg', $nodes, 'Uploading config...')
  upload_file($validation_file, '/tmp/validate.yaml', $nodes, 'Uploading validation file...')

  # this configure task runs in noop mode/dry-run. It won't make changes
  $r2 = run_task(napalm::configure, $nodes,'Updating banner...',
  'user'        => $user,
  'password'    => $password,
  'vendor'      => $vendor,
  'hostname'    => $hostname,
  'config_file' => '/tmp/banner.cfg',
  'strategy'    => 'merge',
  'debug'       => $debug,
  'dry_run'     => true)
  $r2.each |$result| {
    $node = $result.target.name
    if $result.ok {
      notice("${result.message}")
    } else {
      notice("${node} errored with a message: ${result.error.message}")
    }
  }


  # run a small validation against the config to see if it's a cisco device
  $r3 = run_task(napalm::validate, $nodes,'Validating config...',
  'user'        => $user,
  'password'    => $password,
  'vendor'      => $vendor,
  'hostname'    => $hostname,
  'validation_file' => '/tmp/validate.yaml')
  $r3.each |$result| {
    $node = $result.target.name
    if $result.ok {
      notice("${result.message}")
    } else {
      notice("${node} errored with a message: ${result.error.message}")
    }
  }
  # cleanup
  run_command('rm -rf /tmp/banner.cfg /tmp/validate.yaml /tmp/virtualenvs/', $nodes, 'Cleaning up')
}
