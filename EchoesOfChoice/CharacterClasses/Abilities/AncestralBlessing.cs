using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class AncestralBlessing : Ability
    {
        public AncestralBlessing()
        {
            Name = "Ancestral Blessing";
            FlavorText = "Invoke the blessing of the ancestors to empower all allies.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 5;
            TargetAll = true;
        }
    }
}
