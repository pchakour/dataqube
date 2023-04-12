import { RoutingProps } from "../../../App";
import { ListRulesPage } from "./list_rules";
import { RulePage } from "./rule";

interface RulesPageProps extends RoutingProps {
  ruleId?: string;
}

export function RulesPage(props: RulesPageProps) {
  return (
    <>
    {props.ruleId ?
      <RulePage ruleId={props.ruleId} /> :
      <ListRulesPage />}
    </>
  );
}