import fs from 'fs/promises';
import path from 'path';
import generateStructure from './initial.js';

/**
 * Converte um nome em kebab-case para PascalCase.
 * @param {string} str - O nome no formato kebab-case.
 * @returns {string} - O nome no formato PascalCase.
 */
const kebabToPascalCase = (str) => {
  return str
    .split('-')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
    .join('');
};

/**
 * Cria um diretório se não existir.
 * @param {string} dirPath - Caminho do diretório a ser criado.
 * @returns {Promise<void>}
 */
const createDirectory = async (dirPath) => {
  try {
    await fs.mkdir(dirPath, { recursive: true });
    console.log(`Diretório criado: ${dirPath}`);
  } catch (error) {
    console.error(`Erro ao criar o diretório ${dirPath}:`, error);
  }
};

/**
 * Cria um arquivo com conteúdo, se não existir.
 * @param {string} filePath - Caminho do arquivo a ser criado.
 * @param {string} content - Conteúdo do arquivo.
 * @returns {Promise<void>}
 */
const createFile = async (filePath, content = '') => {
  try {
    if (!(await fileExists(filePath))) {
      await fs.writeFile(filePath, content, 'utf8');
      console.log(`Arquivo criado: ${filePath}`);
    }
  } catch (error) {
    console.error(`Erro ao criar o arquivo ${filePath}:`, error);
  }
};

/**
 * Verifica se um arquivo existe.
 * @param {string} filePath - Caminho do arquivo.
 * @returns {Promise<boolean>} - Retorna true se o arquivo existir, false caso contrário.
 */
const fileExists = async (filePath) => {
  try {
    await fs.access(filePath);
    return true;
  } catch {
    return false;
  }
};

/**
 * Carrega um template e substitui os placeholders pelos valores fornecidos.
 * @param {string} templatePath - Caminho do template.
 * @param {Object} substitutions - Substituições para os placeholders.
 * @returns {Promise<string>} - O conteúdo do template com as substituições aplicadas.
 */
const loadTemplate = async (templatePath, substitutions) => {
  try {
    let content = await fs.readFile(templatePath, 'utf8');
    Object.keys(substitutions).forEach(key => {
      const value = substitutions[key];
      content = content.replace(new RegExp(`{{${key}}}`, 'g'), value);
    });
    return content;
  } catch (error) {
    console.error(`Erro ao carregar o template ${templatePath}:`, error);
    return '';
  }
};

/**
 * Gera a estrutura de uma tela (screen).
 * @param {string} pageName - Nome da tela.
 * @returns {Promise<void>}
 */
const generateScreenStructure = async (pageName) => {
  const kebabCaseName = pageName.toLowerCase();
  const pascalCaseName = kebabToPascalCase(pageName);
  const pagePath = path.join('app', 'screens', kebabCaseName);

  await createDirectory(pagePath);

  const indexContent = await loadTemplate(path.join('app/shared/config/templates', 'index.ts.tpl'), { PascalCaseName: pascalCaseName });
  await createFile(path.join(pagePath, 'index.ts'), indexContent);

  await Promise.all([
    createDirectory(path.join(pagePath, 'api')),
    createDirectory(path.join(pagePath, 'ui')),
    createDirectory(path.join(pagePath, 'model'))
  ]);

  const [apiContent, uiContent, modelContent] = await Promise.all([
    loadTemplate(path.join('app/shared/config/templates', 'api.ts.tpl'), { PascalCaseName: pascalCaseName }),
    loadTemplate(path.join('app/shared/config/templates', 'screen.tsx.tpl'), { PascalCaseName: pascalCaseName }),
    loadTemplate(path.join('app/shared/config/templates', 'model.ts.tpl'), { PascalCaseName: pascalCaseName })
  ]);

  await Promise.all([
    createFile(path.join(pagePath, 'api', `${kebabCaseName}-api.ts`), apiContent),
    createFile(path.join(pagePath, 'ui', `${kebabCaseName}-screen.tsx`), uiContent),
    createFile(path.join(pagePath, 'model', `${kebabCaseName}-model.ts`), modelContent)
  ]);
};

/**
 * Gera a estrutura de um componente.
 * @param {string} componentName - Nome do componente.
 * @returns {Promise<void>}
 */
const generateComponentStructure = async (componentName) => {
  const kebabCaseName = componentName.toLowerCase();
  const pascalCaseName = kebabToPascalCase(componentName);
  const componentPath = path.join('app', 'shared', 'ui', kebabCaseName);

  await createDirectory(componentPath);

  const componentContent = await loadTemplate(path.join('app/shared/config/templates', 'component.tsx.tpl'), { PascalCaseName: pascalCaseName });
  await createFile(path.join(componentPath, `${kebabCaseName}.tsx`), componentContent);
};

/**
 * Função principal para rodar o processo de geração de estrutura.
 * @param {string} type - Tipo de estrutura ('screen' ou 'component').
 * @param {string} name - Nome do componente ou tela.
 */
const run = async (type, name) => {
  const actions = {
    screen: generateScreenStructure,
    component: generateComponentStructure,
    start: generateStructure,
    default: () => console.log('\nTipo inválido. \nUse "screen", "component", ou "start" para iniciar a estrutura FSD. \n\nExemplos: \n\t node fsd.js screen Home \n\t node fsd.js component primart-button ou \n\t node fsd.js start'),
  };

  const action = actions[type] || actions.default;
  await action(name);
};

const args = process.argv.slice(2);
const [type, name] = args;

run(type, name);
