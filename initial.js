const fs = require('fs').promises;
const path = require('path');

/**
 * Função utilitária para criar pastas de forma recursiva.
 * @param {string} folderPath Caminho da pasta a ser criada
 * @param {object} subfolders Subpastas a serem criadas
 */
async function createFolder(folderPath, subfolders) {
  try {
    await fs.mkdir(folderPath, { recursive: true });
    console.log(`Pasta criada: ${folderPath}`);
  } catch (error) {
    console.error(`Erro ao criar pasta: ${folderPath}`, error);
  }

  if (typeof subfolders === 'object') {
    for (const [subfolder, nestedSubfolders] of Object.entries(subfolders)) {
      await createFolder(path.join(folderPath, subfolder), nestedSubfolders);
    }
  }
}

/**
 * Função para criar arquivos de template a partir de um mapa.
 * @param {string} templatesPath Caminho onde os templates serão criados
 * @param {object} templates Map de arquivos com seus respectivos conteúdos
 */
async function createTemplateFiles(templatesPath, templates) {
  try {
    await fs.mkdir(templatesPath, { recursive: true });

    for (const [fileName, content] of Object.entries(templates)) {
      const filePath = path.join(templatesPath, fileName);
      await fs.writeFile(filePath, content, 'utf8');
      console.log(`Arquivo criado: ${filePath}`);
    }

    console.log('Templates criados com sucesso!');
  } catch (error) {
    console.error('Erro ao criar os arquivos de templates:', error);
  }
}

/**
 * Função para criar o arquivo principal "App.tsx"
 */
async function createAppFile() {
  const appContent = `import { View } from 'react-native';
import { ReactElement } from 'react';

export default function App(): ReactElement {
  return (
    <View />
  );
}
`;

  try {
    await fs.writeFile(path.resolve(__dirname, 'app', 'App.tsx'), appContent, 'utf8');
    console.log('Arquivo App.tsx criado com sucesso');
  } catch (error) {
    console.error('Erro ao criar o arquivo App.tsx', error);
  }
}

/**
 * Função principal que orquestra a criação de pastas, arquivos e templates.
 */
async function generateStructure() {
  const basePath = path.resolve(__dirname, 'app');
  const folderStructure = {
    screens: {},
    shared: {
      ui: {},
      api: {},
      model: {},
      config: {
        templates: {},
      },
      i18n: {},
      router: {},
    },
  };

  const templates = {
    'api.ts.tpl': `export const fetch{{PascalCaseName}}Data = () => {\n\n};\n`,
    'index.ts.tpl': ``,
    'component.tsx.tpl': `import { ReactElement } from 'react';
import { StyleSheet, View } from 'react-native';

const {{PascalCaseName}} = (): ReactElement => {
  return (
    <View style={styles.container}>
      {{PascalCaseName}} Component
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

export default {{PascalCaseName}};\n`,
    'screen.tsx.tpl': `import { ReactElement } from 'react';
import { StyleSheet, View } from 'react-native';

const {{PascalCaseName}} = (): ReactElement => {
  return (
    <View style={styles.container}>
      {{PascalCaseName}} Screen
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

export default {{PascalCaseName}};\n`,
    'model.ts.tpl': `export interface {{PascalCaseName}}Model {\n\n};\n`
  };

  try {
    await fs.mkdir(basePath, { recursive: true });
    await createFolder(basePath, folderStructure);

    const templatesPath = path.join(basePath, 'shared', 'config', 'templates');
    await createTemplateFiles(templatesPath, templates);

    await createAppFile();

    console.log('Estrutura de pastas e arquivos criada com sucesso!');
  } catch (error) {
    console.error('Erro ao gerar a estrutura de pastas e arquivos', error);
  }
}

generateStructure();
