import { availableParallelism, totalmem } from 'os';
import { readFileSync, writeFileSync } from 'fs';

const memoryAvailable = totalmem();
const cpuThreads = availableParallelism();

/**
 * @param {number} bytes 
 * @returns {number}
 */
const convertBytesToMegabytes = (bytes) => bytes / 1024 ** 2;

const memToJVM = Math.round(convertBytesToMegabytes(memoryAvailable) * 0.5);
const memToMeta = memToJVM * 0.5;

const gradleProperties = {
  'org.gradle.jvmargs': `-Xmx${memToJVM}m -XX:MaxMetaspaceSize=${memToMeta}m -XX:+HeapDumpOnOutOfMemoryError`,
  'org.gradle.workers.max': cpuThreads,
  'org.gradle.daemon': true,
  'org.gradle.parallel': true,
  'android.enableShrinkResourcesInReleaseBuilds': true,
  'android.enableProguardInReleaseBuilds': true,
  'android.enableAapt2': true,
};

const path = './android/gradle.properties';

/**
 * @param {string} filePath
 * @param {Record<string, any>} properties
 * @returns {void}
 */
function updateGradleProperties(filePath, properties) {
  const fileContent = readFileSync(filePath, 'utf8');
  const lines = fileContent.split('\n');

  Object.keys(properties).forEach(key => {
    const index = lines.findIndex(line => line.startsWith(key));
    if (index !== -1) {
      lines.splice(index, 1);
    }
  });

  const insertLine = 12;
  const newProperties = Object.entries(properties).map(([key, value]) => `${key}=${value}`).join('\n');
  lines.splice(insertLine, 0, newProperties);

  writeFileSync(filePath, lines.join('\n'));
}

function start() {
  try {
    updateGradleProperties(path, gradleProperties);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

start();