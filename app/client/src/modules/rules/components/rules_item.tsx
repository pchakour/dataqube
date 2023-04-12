import { Box, Link } from '@chakra-ui/react';
import { Link as ReachLink } from '@reach/router';
import { IRulesModel } from '../../../../../common/model/rules_model';

interface RulesProps {
  rule: IRulesModel;
}

export function RulesItem({rule}: RulesProps) {
  return (
    <Box h='100px' bg="gray.100" border='1px solid #ddd' padding={5} paddingTop={2}>
      <Link color="blue.500" fontWeight='bold' as={ReachLink} to={`/rules/${rule.id}`}>{rule.name}</Link>
    </Box>
  );
}