# Fundamentos ABAP Core

A SAP (Systems, Applications, and Products in Data Processing) é a líder global em softwares de gestão empresarial (ERP). Ela está no centro das grandes empresas porque atua como o "sistema nervoso central" da organização: centraliza dados de finanças, RH, logística, vendas e produção em uma única fonte de verdade. Isso elimina silos de informação, automatiza processos complexos e garante conformidade e escala global.

O Ambiente de Trabalho do Desenvolvedor SAP hoje vive em dois mundos: o tradicional e o moderno. Para atuar em projetos S/4HANA e na nuvem, é essencial dominar a transição da interface clássica para as novas ferramentas de desenvolvimento.

O desenvolvimento SAP passa por uma grande mudança de paradigma. O foco é garantir que o sistema principal seja facilmente atualizável e preparado para a nuvem, evitando o emaranhado de customizações pesadas do passado..

## O Ecossistema SAP

O portfólio da SAP vai muito além do ERP, dividindo-se em três pilares principais:

* **O Core (ERP):** O sistema central onde ocorrem as transações pesadas (compras, faturamento, contabilidade). O produto atual é o **S/4HANA**.
* **Plataforma (SAP BTP):** A *Business Technology Platform* é a fundação tecnológica na nuvem. É onde as empresas criam extensões personalizadas, integram o SAP com sistemas não-SAP, gerenciam dados (Analytics) e aplicam Inteligência Artificial, tudo sem modificar o "core" do ERP.
* **Soluções por Área de Negócio (LoB):** Sistemas em nuvem especializados adquiridos pela SAP que se conectam ao ERP. Exemplos: **Ariba** (compras e cadeia de suprimentos), **SuccessFactors** (recursos humanos), **Concur** (gestão de despesas) e **Customer Experience / CX** (vendas e marketing).

---

## O Ciclo de um Projeto SAP (SAP Activate)

Para implementar ou migrar o sistema, utiliza-se a metodologia ágil **SAP Activate**, que divide o projeto nestas fases:

1. **Discover:** A empresa avalia o valor do negócio, explora as soluções e define a estratégia (ex: migrar para a nuvem).
2. **Prepare:** Planejamento inicial, formação da equipe, infraestrutura e kick-off do projeto.
3. **Explore:** Fase de *Fit-to-Standard*. A equipe analisa os processos de negócios padrão da SAP e identifica lacunas (gaps) com as necessidades da empresa, gerando o desenho da solução (Blueprint).
4. **Realize:** O sistema é construído e configurado. Os desenvolvedores criam as extensões necessárias e ocorrem os testes unitários e de integração.
5. **Deploy:** Preparação final. Inclui o treinamento dos usuários, simulações rigorosas, migração de dados do sistema antigo e o **Go-Live** (a virada de chave para o novo sistema).
6. **Run:** O sistema está em produção. Inicia-se o suporte contínuo (hipercare) e a adoção de atualizações de inovação.

---

## Conceitos-Chave

* **S/4HANA:** É a 4ª geração do ERP da SAP. O "HANA" refere-se ao banco de dados *in-memory* (processa dados na memória RAM e não em discos rígidos), permitindo análises em tempo real e processamento ultrarrápido.
* **RISE e GROW:** São pacotes comerciais de "ERP como serviço" (Cloud) para facilitar a adoção do S/4HANA.
* **RISE with SAP (Private Edition):** Focado em clientes já existentes que possuem sistemas complexos (ECC) e precisam de uma transição gradual e altamente customizada para a nuvem privada.
* **GROW with SAP (Public Edition):** Focado em novos clientes (mid-market) que desejam implementar o ERP rapidamente na nuvem pública, adotando as melhores práticas padrão com zero customização complexa.
* **Landscape:** É a arquitetura de ambientes do sistema. As alterações nunca são feitas diretamente onde a empresa opera.
* **Desenvolvimento (DEV):** Onde os consultores configuram o sistema e os programadores criam códigos.
* **Qualidade (QAS):** Onde as validações e testes integrados ocorrem.
* **Produção (PRD):** O ambiente real onde a empresa trabalha. O código viaja de um ambiente para o outro através de **Request for Transports (Requests/Transportes)**.

---

## Antes de Seguir (Perguntas Diretas)

### Qual a diferença entre ECC e S/4HANA?

A arquitetura e a velocidade.

| Característica | SAP ECC (ERP Central Component) | SAP S/4HANA |
| --- | --- | --- |
| **Banco de Dados** | Roda em qualquer banco (Oracle, SQL Server, IBM). Armazenamento tradicional em disco. | Roda **exclusivamente** no SAP HANA (in-memory). Processamento em tempo real. |
| **Modelo de Dados** | Tabelas complexas com redundância (ex: dezenas de tabelas financeiras separadas). | Tabelas simplificadas (ex: o *Universal Journal*, tabela ACDOCA, unifica finanças e controladoria). |
| **Interface (UI)** | SAP GUI (telas cinzas, estilo anos 90, focadas em transações complexas no desktop). | SAP Fiori (interface web moderna, responsiva, baseada em aplicativos e focada na experiência do usuário). |

### Quem faz o quê em um projeto SAP?

* **Consultor Funcional:** O especialista nas regras de negócio (Finanças, Logística, etc.). Ele conversa com o cliente, traduz as necessidades para o sistema, faz a configuração padrão (*Customizing*) e escreve a especificação funcional para os desenvolvedores.
* **Desenvolvedor (ABAP / Fiori):** O programador. Se o cliente precisa de um relatório específico, uma integração ou uma tela que não existe no padrão SAP, ele programa essa solução baseada na documentação do Funcional.
* **Consultor Basis:** O administrador da infraestrutura (o "TI" do SAP). Ele instala o sistema, gerencia o banco de dados, monitora a performance, aplica atualizações, gerencia a criação de usuários/perfis de acesso e transporta as mudanças (DEV > QAS > PRD).
* **Key User (Usuário-Chave):** O funcionário especialista do cliente (ex: o gerente de faturamento). Ele não é da consultoria. O Key User valida se o que foi configurado atende à rotina real da empresa, realiza os testes de homologação e, no final, treina os demais funcionários do seu departamento.

O Ambiente de Trabalho do Desenvolvedor SAP hoje vive em dois mundos: o tradicional e o moderno. Para atuar em projetos S/4HANA e na nuvem, é essencial dominar a transição da interface clássica para as novas ferramentas de desenvolvimento.

## As Ferramentas

### SAP GUI: Para que ele ainda serve?

O SAP GUI (Graphical User Interface) é o programa clássico (SAP Logon) que instalamos na máquina para acessar o ERP. Embora a SAP esteja migrando a experiência do usuário para o navegador (SAP Fiori) e o desenvolvimento para o Eclipse, o SAP GUI continua sendo vital para:

* **Transações Funcionais e de Negócio:** Onde consultores testam processos antigos que ainda não têm apps Fiori.
* **Customizing (SPRO):** Toda a parametrização e configuração do sistema (regras de negócio, empresas, impostos) ainda é feita aqui.
* **Administração (Basis):** Monitoramento de performance, criação de usuários (SU01), análise de dumps (ST22) e gestão de transportes (SE09).

### Eclipse com ADT: A IDE do ABAP Moderno

O Eclipse é uma IDE (ambiente de desenvolvimento) de mercado aberto. A SAP adotou o Eclipse e criou um plugin chamado **ADT (ABAP Development Tools)** para transformá-lo na ferramenta oficial do desenvolvedor ABAP.

* **Por que mudar?** O antigo ambiente de código do SAP GUI (transação SE80) não suporta as novas tecnologias em nuvem. O Eclipse oferece autocompletar avançado, refatoração de código, atalhos rápidos e integração com Git.

### Comparação Prática

| Característica | SAP GUI (Transações SE80 / SE38) | Eclipse com ADT |
| --- | --- | --- |
| **Foco atual** | Configuração, administração e manutenção de código legado (ECC). | Desenvolvimento moderno (S/4HANA e BTP). |
| **Navegação** | Baseada em códigos de transações (T-Codes). | Baseada em Projetos (Project Explorer). |
| **Interface** | Múltiplas janelas separadas, editor de texto simples. | Múltiplas abas integradas, visão de classes, syntax highlight moderno. |
| **Novas Tecnologias** | Não suporta criações modernas (CDS, RAP). | **Obrigatório** para desenvolvimento Cloud e S/4HANA. |

### Conceitos das Ferramentas

* **SAP GUI (como conceito de uso):** A porta de entrada para a "cozinha" do sistema on-premise, focado em *Customizing*, operações de Basis e execução de processos.
* **ADT (ABAP Development Tools):** É o pacote de ferramentas e plugins que instalamos dentro do Eclipse (através do repositório de software da SAP) para que ele entenda a linguagem ABAP e consiga se comunicar com os servidores SAP.
* **ABAP Project:** É o tipo de projeto criado no Eclipse para conectar a IDE a um servidor SAP **On-Premise** (ou Private Cloud). Ele herda automaticamente as conexões que você já tem configuradas no seu SAP Logon (SAP GUI).
* **ABAP Cloud Project:** É o projeto criado para se conectar ao **SAP BTP (ABAP Environment)**. Ele não usa o SAP Logon; a conexão é feita via internet (URL do BTP) autenticada com sua conta na nuvem (Service Keys ou SAP Universal ID).
* **Exclusividades do ADT:** Tecnologias modernas de modelagem de dados e APIs como **CDS Views** (Core Data Services), **RAP** (RESTful Application Programming Model) e **Service Bindings** (para publicar APIs OData) **só podem ser criadas no Eclipse com ADT**. O SAP GUI simplesmente não tem suporte para esses objetos.

O desenvolvimento SAP passou por uma grande mudança de paradigma. O foco agora é garantir que o sistema principal seja facilmente atualizável e preparado para a nuvem, evitando o emaranhado de customizações pesadas do passado. Abaixo, detalhamos a estratégia do Clean Core e as novas formas de criar extensões.

## Clean Core

* **O que é Clean Core e por que a SAP cobra isso:** Historicamente, modificações profundas no código padrão (o famoso código Z) impediam as empresas de fazer atualizações de versão. A SAP impulsiona o Clean Core para que o ERP possa receber inovações contínuas, garantindo que o sistema base permaneça intacto e as customizações sobrevivam às atualizações sem quebrar.
* **A Matriz de Decisão:** A mudança na forma de pensar a solução. Em vez de ir direto para a programação ABAP clássica, o arquiteto avalia o nível de complexidade para escolher o caminho de extensão correto (In-app, On-stack ou Side-by-side).
* **As Novas Stacks de Desenvolvimento:** O abandono de tecnologias antigas (como relatórios ALV ou Dynpro) em favor de frameworks modernos que conversam nativamente com a web, APIs e a nuvem.
* **A Conscientização do Time:** O desafio cultural. Desenvolvedores, consultores funcionais e clientes precisam abandonar o "jeito antigo" (usar *user exits* e *enhancements* não liberados) e adotar as novas boas práticas desde o dia zero do projeto.

### Conceitos-Chave de Clean Core

* **Clean Core:** A filosofia e governança de manter o ERP o mais próximo possível do padrão (standard). Qualquer customização necessária deve ser feita de forma isolada, utilizando estritamente as APIs e os "pontos de extensão" oficiais e liberados pela SAP.
* **Key User Extensibility:** Extensão feita sem código (No-Code/Low-Code) dentro do ERP. Permite que um usuário-chave ou consultor funcional adicione campos personalizados, crie lógicas simples ou adapte formulários diretamente pelo navegador (SAP Fiori), sem envolver um desenvolvedor.
* **On-stack Extensibility (Developer Extensibility):** Desenvolvimento focado no desenvolvedor, rodando **dentro** do S/4HANA, mas usando **ABAP Cloud**. O código habita o ERP, mas é "limpo" porque consome apenas objetos e APIs públicas da SAP (Tier 1), garantindo segurança em futuros upgrades.
* **Side-by-side Extensibility:** Desenvolvimentos construídos completamente **fora** do ERP, hospedados na plataforma **SAP BTP**. Eles se comunicam com o core (ERP) através de APIs e eventos. É a escolha obrigatória para aplicativos que integram sistemas de terceiros, exigem alto processamento independente, usam Inteligência Artificial ou são acessados por usuários externos (como um portal de fornecedores).
* **Stacks Modernas:** Os frameworks oficiais da SAP para a nova era:
* **RAP (RESTful ABAP Programming Model):** Arquitetura para construir serviços web e aplicativos Fiori utilizando a linguagem ABAP, focado no ambiente On-stack.
* **CAP (Cloud Application Programming Model):** Arquitetura para construir aplicações modernas no SAP BTP (Side-by-side) utilizando linguagens de mercado, como **Node.js** e **Java**.

### Dada uma demanda, você sabe dizer qual caminho de extensão usar e por quê?

Para manter o Clean Core, a decisão deve seguir do caminho mais simples e menos invasivo para o mais complexo.

| Cenário / Demanda da Empresa | Caminho Recomendado | Por quê? |
| --- | --- | --- |
| Criar um novo campo (ex: "Cor do Produto") no cadastro de materiais e exibi-lo na tela padrão. | **Key User Extensibility** | Resolve rapidamente via Fiori, sem custo de desenvolvimento pesado. É 100% à prova de upgrades. |
| Criar uma nova tabela Z complexa e regras de cálculo específicas que cruzam dados financeiros internos do ERP. | **On-stack (ABAP Cloud / RAP)** | Os dados e as regras são vitais para o core e precisam de alta performance de leitura no banco HANA do ERP. |
| Criar um app móvel para clientes finais acompanharem a entrega do pedido com integração ao Google Maps. | **Side-by-side (SAP BTP / CAP)** | Usuários externos não devem acessar o ERP diretamente. Além disso, integra serviços externos (Google Maps) que não pertencem ao core. |

## O Modelo de 3 Tiers (3-Tier Extensibility Model)

A classificação em Tiers (camadas) é a bússola do desenvolvedor na estratégia **Clean Core** para extensões **On-stack** no S/4HANA.

Como o programador agora atua no mesmo ambiente onde o sistema padrão roda, a SAP criou esse modelo de três camadas para definir de forma estrita **quais objetos da SAP** (tabelas, classes, APIs, funções) o cliente tem permissão para consumir. O objetivo é criar um "contrato de estabilidade" para que o seu código personalizado não quebre quando a SAP atualizar a versão do ERP.

### Tier 1: ABAP Cloud (O Mundo Ideal e "Clean")

* **O que é:** São os objetos e APIs oficiais, documentados e publicamente **liberados pela SAP** para o desenvolvimento moderno (possuem o status técnico de *Released for Cloud Development*).
* **O que inclui:** CDS Views liberadas para leitura (ex: `I_JournalEntry`), BAdIs modernos para ampliações, objetos RAP e classes utilitárias padrão da SAP.
* **A Regra:** Você **deve** basear seu desenvolvimento On-stack aqui. A SAP garante que os objetos do Tier 1 não mudarão de comportamento ou desaparecerão em futuras atualizações. O código feito 100% no Tier 1 é totalmente Clean Core.

### Tier 2: Cloud API Enablement (A Ponte de Transição)

* **O que é:** Uma camada de mitigação e customização "controlada". Acontece quando a empresa precisa de uma funcionalidade do sistema, mas a SAP ainda não liberou uma API oficial no Tier 1 para aquilo.
* **Como funciona:** O desenvolvedor usa o código clássico legado, mas o "esconde" dentro de um objeto próprio personalizado (um *Wrapper*, como uma classe Z). Esse wrapper serve como um adaptador ou isolante térmico entre o código moderno e o código antigo.
* **A Regra:** É tolerado como exceção. Assim que a SAP lançar uma API oficial no Tier 1 em uma atualização futura, a empresa deve deletar o *Wrapper* do Tier 2 e plugar sua aplicação diretamente no Tier 1.

### Tier 3: Classic ABAP (O Legado e "Sujo")

* **O que é:** É o desenvolvimento clássico (idêntico ao do antigo SAP ECC). Envolve usar qualquer objeto ou dado do sistema que **não** esteja liberado para uso público pela SAP.
* **O que inclui:** Acessar diretamente tabelas padrão do banco de dados (como fazer um `SELECT` na tabela MARA, de materiais, ou BKPF, de contabilidade), usar BAPIs antigas, modificar o código standard (*User Exits* intrusivos).
* **A Regra:** **Evitar a todo custo.** Códigos no Tier 3 quebram a filosofia do Clean Core. Durante um upgrade do S/4HANA, a SAP pode alterar a estrutura de uma tabela ou excluir uma função antiga sem aviso prévio. Se isso acontecer, seu sistema vai travar (gerando os caros processos de correção de código em época de atualização).

### Resumo Prático

| Tier | Nível de "Limpeza" (Clean Core) | Risco em Upgrades | Como o desenvolvedor atua? |
| --- | --- | --- | --- |
| **Tier 1** | 100% Clean Core | **Nenhum** | Consome apenas APIs (CDS, RAP, BAdIs) com selo de aprovação (*Released*). |
| **Tier 2** | Aceitável (Transição) | **Baixo / Médio** | Cria um *Wrapper* (Capa Protetora) em volta de uma funcionalidade antiga não liberada. |
| **Tier 3** | Dívida Técnica (Sujo) | **Altíssimo** | Faz acessos diretos, invasivos e não autorizados ao "coração" do ERP. |
