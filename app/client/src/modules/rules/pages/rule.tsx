import { Button, Input, Textarea } from '@chakra-ui/react';
import React, { useCallback, useEffect, useState } from 'react';
import { PageTemplate } from '../../../components/PageTemplate/PageTemplate';
import { useServices } from '../../../hooks/use_services';
import _ from 'lodash';
import { IRulesModel } from '../../../../../common/model/rules_model';
import { RoutingProps } from '../../../App';

interface RulePageProps {
  ruleId?: string;
}

export function RulePage({ ruleId }: RulePageProps) {
  const services = useServices();
  const [rules, setRules] = useState<IRulesModel['rules']>();
  const [name, setName] = useState<IRulesModel['name']>();

  const save = useCallback(() => {
    if (name && rules) {
      services.rules.save({
        name,
        rules,
      });
    }
  }, [rules, services.rules, name]);

  const onRulesChange = useCallback((event: React.ChangeEvent<HTMLTextAreaElement>) => {
    setRules(event.target.value);
  }, []);

  const onNameChange = useCallback((event: React.ChangeEvent<HTMLInputElement>) => {
    setName(event.target.value);
  }, []);

  // useEffect(() => {
  //   if(ruleId) {
  //     services.rules.get(ruleId).then(() => {
  //     });
  //   }
  // }, [ruleId]);

  return (
    <PageTemplate marginTop={20} marginBottom={20} select='rules' title="Rules">
      <Input onChange={onNameChange} type='text' />
      <Textarea onChange={onRulesChange} placeholder='Here is a sample placeholder' />
      <Button onClick={save} disabled={_.isEmpty(rules)}>Save</Button>
    </PageTemplate>
  );
}