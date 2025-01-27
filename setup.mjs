#!/usr/bin/env -S ./node_modules/.bin/zx

// @issue: TTY Zx https://github.com/google/zx/issues/407 OUT OF SCOPE
// @isssue TTY Wireite https://github.com/google/wireit/issues/56

const PLATFORM = require('os').platform()
const ROOT_DIR = __dirname

// Don't add automatic quotes: required to not mess up with finch run commands
$.quote = (str) => {
  return str
}

const ssoLoginProd = async () => {
    await $`aws sso login --profile apps-prod`
}

const ssoLoginStg = async () => {
  await $`aws sso login --profile apps-stg`
}

const ssoLoginDev = async () => {
    await $`aws sso login --profile apps-dev`
}

const ssmTunnel = async (profile, target, host, port) => {
  await $`aws ssm --profile ${profile} start-session --target ${target} --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{"host":["${host}"],"portNumber":["5432"], "localPortNumber":["${port}"]}'`
}

const ssmTunnelProd = async () => {
  await ssmTunnel('apps-prod', 'TODO', 'TODO', 55432)
}

const ssmTunnelStg = async () => {
  await ssmTunnel('apps-stg', 'TODO', 'TODO', 55432)
}

const ssmTunnelDev = async () => {
    await ssmTunnel('apps-dev', 'TODO', 'TODO', 55432)
}

const main = async () => {
  const [command] = argv._
  console.info("exec command.", command)
  switch (command) {
    case 'sso-login-prod':
      await ssoLoginProd()
      break
    case 'sso-login-stg':
      await ssoLoginStg()
      break
    case 'sso-login-dev':
      await ssoLoginDev()
      break
    case 'ssm-tunnel-prod':
      await ssmTunnelProd()
      break
    case 'ssm-tunnel-stg':
      await ssmTunnelStg()
      break
    case 'ssm-tunnel-dev':
      await ssmTunnelDev()
      break
  }
}

try {
  main()
} catch (e) {
  console.error(e)
  process.exit(1)
}
