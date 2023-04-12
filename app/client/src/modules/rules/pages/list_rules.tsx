import { Button, StackDivider, VStack } from "@chakra-ui/react";
import { useEffect, useState } from "react";
import { PageTemplate } from "../../../components/PageTemplate/PageTemplate";
import { useServices } from "../../../hooks/use_services";
import { RulesItem } from "../components/rules_item";
import { IRulesModel } from "../../../../../common/model/rules_model";
import { navigate } from "@reach/router"


export function ListRulesPage() {
  const services = useServices();
  const [rules, setRules] = useState<IRulesModel[]>([]);

  useEffect(() => {
    services.rules.search().then((rules) => {
      setRules(rules);
    });
  }, [services]);

  return (
    <PageTemplate
      marginTop={20}
      marginBottom={20}
      select='rules'
      title="Rules"
      rightButtons={[<Button key='new' onClick={() => navigate('/rules/new')}>Add</Button>]}
    >
      <VStack
        divider={<StackDivider borderColor='gray.200' />}
        spacing={4}
        align='stretch'
      >
        {
          rules.map((rule) => (
            <RulesItem key={rule.id} rule={rule} />
          ))
        }
      </VStack>
    </PageTemplate>
  );
}