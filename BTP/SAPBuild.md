# SAP BUILD

O SAP Build oferece diversas maneiras de atender às necessidades de negócios, fornecendo soluções visuais, tradicionais e com suporte de IA para criar processos automatizados, extensões de aplicativos e sites de negócios na empresa inteligente.

Demonstra-se como a integração perfeita das soluções low-code do SAP Build — incluindo SAP Build Process Automation, SAP Build Apps e SAP Build Work Zone — garante o desenvolvimento rápido de um cenário completo por meio da funcionalidade de arrastar e soltar. Isso não apenas acelera o processo de desenvolvimento, como também minimiza a necessidade de programação extensa, tornando-o acessível a uma gama mais ampla de usuários.

## Relação SAP Build e BTP

No âmbito dos produtos SAP Build, destinos configurados corretamente são vitais para a integração e comunicação perfeitas entre vários serviços, como SAP Build Process Automation, SAP Build Work Zone, SAP Build Apps e SAP S/4HANA Cloud. Essas configurações garantem que os processos sejam acionados corretamente e que os dados sejam transferidos de forma consistente, dando suporte a fluxos de trabalho coerentes. O suporte para aplicativos móveis e HTML5 oferece acesso flexível ao SAP Build Process Automation e a outros produtos SAP Build, permitindo que os usuários integrem esses serviços aos seus fluxos de trabalho existentes de qualquer lugar.

- SAP Build Apps

Possui recursos mais sofisticados para permitir que usuários de negócios e desenvolvedores mais avançados aproveitem ao máximo a plataforma. A integração do SAP Build Apps com a SAP Business Technology Platform (BTP) oferece diversas funcionalidades práticas. Uma das principais vantagens é a capacidade de utilizar o Editor de Fórmulas para incorporar dinamicamente variáveis ​​que recuperam informações do SAP BTP, como o nome ou o endereço de e-mail do usuário autenticado. Por exemplo, o endereço de e-mail pode ser acessado usando uma variável específica dentro do Editor de Fórmulas.

- SAP Build Process Automation
- SAP Build Workzone

Além dos principais recursos de criação de aplicativos, existem diversas funcionalidades que facilitam a criação de extensões SAP e outros aplicativos relacionados ao SAP:

**Destinos:**
Os destinos são conexões com sistemas de back-end, geralmente sistemas SAP, definidos no SAP BTP para uso pelos serviços do SAP BTP. O SAP Build reconhece os destinos definidos no cockpit do SAP BTP e pode criar recursos de dados (ou seja, conexões com sistemas de back-end) com base nesses destinos. A documentação da SAP Systems descreve como configurar destinos para aplicativos do SAP Build.

Na SAP Business Technology Platform (BTP), os destinos são endpoints predefinidos que facilitam a comunicação segura entre seus aplicativos e sistemas externos, sejam eles locais ou na nuvem. Eles armazenam detalhes de conexão cruciais, como URLs e informações de autenticação, garantindo a troca segura de dados.

O destino SAP BTP sap_process_automation_service_user_access permite a comunicação segura e eficiente entre vários serviços SAP, facilitando novos fluxos de processos entre o SAP Build Apps e o SAP Build Process Automation para acionar processos de forma integrada.

**Implantação no SAP BTP:**
O SAP Build Apps permite que você implante seu aplicativo para ser executado no SAP BTP. O SAP Build Apps permite que você compile seu projeto em um arquivo MTAR, um arquivo de aplicativo reconhecido pelo ambiente Cloud Foundry do SAP BTP, e então envie o arquivo para ser implantado no SAP BTP.

**Autenticação SAP BTP:**
Você pode tornar obrigatória a autenticação dos usuários com o SAP BTP antes de usar o aplicativo. Isso é necessário para muitas outras funcionalidades, como referenciar destinos do SAP BTP.

1. Quais recursos o SAP Build Apps oferece para facilitar a criação de aplicativos?
O SAP Build Apps oferece os seguintes recursos para facilitar a criação de aplicativos: "Arrastar e soltar componentes pré-construídos para criar a interface do usuário", "Definir conexões simples com dados de back-end por meio de formulários" e "Criar lógica para responder a eventos do usuário e do aplicativo".

2. O destino SAP BTP sap_process_automation_service_user_access utiliza o mecanismo OAuth2JWTBearer com JSON Web Tokens (JWT) para acesso autorizado.
O destino SAP BTP sap_process_automation_service_user_access utiliza o mecanismo OAuth2JWTBearer com JSON Web Tokens (JWT) para acesso autorizado.

3. O que são destinos no contexto do SAP Build?
Os destinos no contexto do SAP Build são conexões com sistemas back-end definidos no SAP BTP.

4. O Marketplace é voltado principalmente para componentes de visualização?
O mercado também oferece uma grande variedade de elementos lógicos e dados.

## Implementando Produtos - Cenários Ponta a Ponta


Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

Set-ExecutionPolicy RemoteSigned" no powershell

npm i -g @sap/cds-dk
npm i -g @sap/cds-dk


cds init

cds init . --nodejs --force

# schema.cds dentro da pasta db 

namespace geo.field;
using { cuid, managed } from '@sap/cds/common';

entity Incidents : cuid, managed {
  title       : String(100);
  description : String;
  status      : String enum { open; in_progress; closed; };
  priority    : Integer;
  latitude    : Decimal(9,6);
  longitude   : Decimal(9,6);
  technician  : Association to Technicians;
}

entity Technicians : cuid {
  name  : String(80);
  email : String;
}


pasta srv arquivo service.cds

using { geo.field as db } from '../db/schema';

service FieldService @(path: '/field') {
  entity Incidents   as projection on db.Incidents;
  entity Technicians as projection on db.Technicians;
}


Para a IA: 
Complete meu schema CDS: adicione uma entidade Categories como code list
(código e descrição) e associe aos Incidents. Adicione também um campo
de data de fechamento nos Incidents. 
Exponha Categories no serviço como readonly.


using { geo.field as db } from '../db/schema';
service FieldService @(path: '/field') {
  entity Incidents   as projection on db.Incidents;
  entity Technicians as projection on db.Technicians;
  @readonly entity Categories as projection on db.Categories;
}

Leandro Dante
service FieldService @(path: '/field') {
  entity Incidents   as projection on db.Incidents;
  entity Categories as projection on db.Categories @(readonly: true);
  entity Technicians as projection on db.Technicians;
}



Crie arquivos CSV de teste em db/data para todas as entidades do meu schema,
com 10 incidentes em coordenadas de cidades brasileiras, 5 técnicos com nomes brasileiros e 4 categorias (elétrica, hidráulica, estrutural, telecom).