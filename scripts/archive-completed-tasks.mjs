import { readFileSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const repoRoot = dirname(dirname(fileURLToPath(import.meta.url)));
const devDir = join(repoRoot, 'Developement');
const task1Path = join(devDir, 'Task1_Engineered.md');
const task2Path = join(devDir, 'Task2_Archived.md');
const task0Path = join(devDir, 'Task0_Raw.md');

const placeholder = '[Placeholder for completion notes';
const taskPattern =
  /(?:<a id="([^"]+)"><\/a>\n)?### \[([xX ])\] ([^\n]+)\n[\s\S]*?(?=\n(?:<a id="[^"]+"><\/a>\n)?### \[[xX ]\] |$)/g;

const task1 = readFileSync(task1Path, 'utf8');
let task2 = readFileSync(task2Path, 'utf8');
let task0 = readFileSync(task0Path, 'utf8');

const remainingHeader = '## Remaining Tasks';
const remainingStart = task1.indexOf(remainingHeader);
if (remainingStart === -1) {
  throw new Error('Task1_Engineered.md is missing "## Remaining Tasks".');
}

const head = task1.slice(0, remainingStart + remainingHeader.length);
const remaining = task1.slice(remainingStart + remainingHeader.length);
const archiveCandidates = [];

const nextRemaining = remaining.replace(
  taskPattern,
  (block, anchor, status, title) => {
    if (!anchor || status.toLowerCase() !== 'x' || block.includes(placeholder)) {
      return block;
    }
    const completedAtMatch = block.match(/- Completed At: ([^\n]+)/);
    if (!completedAtMatch) {
      return block;
    }
    archiveCandidates.push({
      anchor,
      title: title.trim(),
      completedAt: completedAtMatch[1].trim(),
      block: block.trim(),
    });
    return '';
  },
);

if (archiveCandidates.length === 0) {
  console.log('No completed task blocks were eligible for archiving.');
  process.exit(0);
}

let nextTask1 = `${head}${nextRemaining}`.replace(/\n{3,}/g, '\n\n');

for (const candidate of archiveCandidates) {
  const archiveLink = `Task2_Archived.md#${candidate.anchor}`;
  const indexLine = `- ${candidate.completedAt}: [${candidate.title}](${archiveLink})`;

  if (!nextTask1.includes(`](${archiveLink})`)) {
    nextTask1 = nextTask1.replace(
      /## Completed Tasks\n/,
      `## Completed Tasks\n\n${indexLine}\n`,
    );
  }

  if (!task2.includes(`<a id="${candidate.anchor}"></a>`)) {
    task2 = `${task2.trim()}\n\n${candidate.block}\n`;
  }

  task0 = task0.replaceAll(
    `Task1_Engineered.md#${candidate.anchor}`,
    archiveLink,
  );
}

writeFileSync(task1Path, `${nextTask1.trimEnd()}\n`);
writeFileSync(task2Path, `${task2.trimEnd()}\n`);
writeFileSync(task0Path, `${task0.trimEnd()}\n`);

console.log(
  `Archived ${archiveCandidates.length} task(s): ${archiveCandidates
    .map((candidate) => candidate.title)
    .join(', ')}`,
);
