const { environment, open } = require("@raycast/api");
const util = require("util");
const exec = util.promisify(require("child_process").exec);
const os = require("os");

let domain = "com.raycast.macos";
let protocol = "raycast";
let shouldForceUpdate = ["1.69.0", "1.69.1", "1.69.2", "1.69.3", "1.70.0", "1.70.1", "1.70.2", "1.70.3"].includes(
  environment.raycastVersion
);

if (environment.raycastVersion.indexOf("alpha") > -1) {
  domain = "com.raycast.macos.internal";
  protocol = "raycastinternal";
  shouldForceUpdate = true;
}

(async () => {
  if (!shouldForceUpdate) {
    return;
  }

  try {
    const { stdout: lastForceCheckedUpdateAt } = await exec(`defaults read ${domain} lastForceCheckedUpdateAt`, {
      timeout: 1000,
    });

    if (Date.now() - parseInt(lastForceCheckedUpdateAt, 10) < 1000 * 60 * 60 * 24) {
      return;
    }
  } catch {
    // Do Nothing
  }

  let canWriteDefaults = true;
  try {
    await exec(`defaults write ${domain} lastForceCheckedUpdateAt -int ${Date.now()}`, { timeout: 1000 });
  } catch {
    canWriteDefaults = false;
  }

  if (!canWriteDefaults) {
    return;
  }

  try {
    const tmpdir = os.tmpdir();
    const plistPath = `${tmpdir}/raycast.plist`;

    let dictExists = true;
    try {
      await exec(`defaults read ${domain} alwaysAllowCommandDeeplinking > ${plistPath}`, { timeout: 1000 });
    } catch (e) {
      dictExists = false;
    }

    await exec(`defaults write ${domain} alwaysAllowCommandDeeplinking -dict-add builtin_command_checkForUpdates 1`, {
      timeout: 1000,
    });

    setTimeout(() => {
      open(`${protocol}://extensions/raycast/raycast/check-for-updates`);

      setTimeout(async () => {
        if (dictExists) {
          await exec(
            `defaults write ${domain} alwaysAllowCommandDeeplinking "$(plutil -convert xml1 -o - ${plistPath})"`,
            { timeout: 1000 }
          );
        } else {
          await exec(`defaults remove ${domain} alwaysAllowCommandDeeplinking`, { timeout: 1000 });
        }
      }, 200);
    }, 50);
  } catch {
    // Do Nothing
  }
})();
