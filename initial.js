const fs = require('fs').promises;
const { template } = require('@babel/core');
const path = require('path');

/**
 * Cria as pastas de forma recursiva conforme a estrutura fornecida
 * @param {string} basePath Caminho base onde as pastas serão criadas
 * @param {object} structure Estrutura de pastas a ser criada
 */
async function createFolders(basePath, structure) {
  for (const [folder, subfolders] of Object.entries(structure)) {
    const folderPath = path.join(basePath, folder);

    try {
      await fs.mkdir(folderPath, { recursive: true });
      console.log(`Pasta criada: ${folderPath}`);

      // Se houver subpastas, chamar recursivamente
      if (typeof subfolders === 'object') {
        await createFolders(folderPath, subfolders);
      }
    } catch (error) {
      console.error(`Erro ao criar pasta: ${folderPath}`, error);
    }
  }
}

/**
 * Função para criar arquivos de template
 */
async function createFiles(basePath) {
  // Definindo os conteúdos dos templates
  const apiTemplateContent = `export const fetch{{PascalCaseName}}Data = () => {

};
`;

  const indexTemplateContent = ``;

  const componentTemplateContent = `import { ReactElement } from 'react';
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

export default {{PascalCaseName}};
`;

  const screenTemplateContent = `import { ReactElement } from 'react';
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

export default {{PascalCaseName}};
`;

  const modelTemplateContent = `export interface {{PascalCaseName}}Model {

}
`;

  // Mapeando os nomes dos arquivos para os conteúdos dos templates
  const templates = {
    'api.ts.tpl': apiTemplateContent,
    'index.ts.tpl': indexTemplateContent,
    'component.tsx.tpl': componentTemplateContent,
    'screen.tsx.tpl': screenTemplateContent,
    'model.ts.tpl': modelTemplateContent,
  };

  // Caminho onde os templates serão criados
  const templatesPath = path.join(basePath, 'shared', 'config', 'templates');

  try {
    // Garantir que o diretório templates existe
    await fs.mkdir(templatesPath, { recursive: true });

    // Criar os arquivos de template com base na estrutura e conteúdo
    for (const [fileName, content] of Object.entries(templates)) {
      const filePath = path.join(templatesPath, fileName);

      // Escrever o conteúdo no arquivo
      await fs.writeFile(filePath, content, 'utf8');
      console.log(`Arquivo criado: ${filePath}`);
    }

    console.log('Templates criados com sucesso!');
  } catch (error) {
    console.error('Erro ao criar os arquivos de templates:', error);
  }
}

/**
 * Cria o arquivo principal "App.tsx"
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
 * Função principal que orquestra a criação de pastas, arquivos e templates
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
  try {
    await fs.mkdir(basePath, { recursive: true });
    await createFolders(basePath, folderStructure);
    await createFiles(basePath);
    await createAppFile();

    console.log('Estrutura de pastas e arquivos criada com sucesso!');
  } catch (error) {
    console.error('Erro ao gerar a estrutura de pastas e arquivos', error);
  }
}

// Executa a geração da estrutura
generateStructure();
