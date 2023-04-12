import { Button, FormControl, FormHelperText, FormLabel, Input, Select } from '@chakra-ui/react';
import React, { useCallback, useEffect, useState } from 'react'
import { PageTemplate } from '../../../components/PageTemplate/PageTemplate';
import { useServices } from '../../../hooks/use_services';
import { IRulesModel } from '../../../../../common/model/rules_model';

export function CreateProjectPage() {
  const services = useServices();
  const [name, setName] = useState<string>();
  const [projectRules, setProjectRules] = useState<string>();
  const [availableRules, setAvailableRules] = useState<IRulesModel[]>([]);

  const onNameChange = useCallback((event: React.ChangeEvent<HTMLInputElement>) => {
    setName(event.target.value);
  }, []);

  const onProjectRulesChange = useCallback((event: React.ChangeEvent<HTMLSelectElement>) => {
    setProjectRules(event.target.value);
  }, []);

  const onSave = useCallback(() => {
    if (name && projectRules) {
      services.projects.save({
        name,
        rules: projectRules,
      });
    }
  }, [services, name, projectRules]);

  useEffect(() => {
    services.rules.search().then(r => setAvailableRules(r));
  }, [services]);

  return (
    <PageTemplate title='Create project' marginTop={30} select='projects'>
      <FormControl>
        <FormLabel>Name</FormLabel>
        <Input type='text' onChange={onNameChange} value={name} />
        <FormHelperText>Enter a name for your project.</FormHelperText>
      </FormControl>
      <FormControl>
        <FormLabel>Rules</FormLabel>
        <Select placeholder='Select rules' onChange={onProjectRulesChange} value={projectRules}>
          {
            availableRules.map((availableRule) => (
              <option key={availableRule.id} value={availableRule.id}>{availableRule.name}</option>
            ))
          }
        </Select>
        <FormHelperText>Select rules to apply for this project.</FormHelperText>
      </FormControl>

      <Button colorScheme='blue' onClick={onSave}>Save</Button>
    </PageTemplate>
  );
}