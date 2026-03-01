using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class PrimalRoar : Ability
    {
        public PrimalRoar()
        {
            Name = "Primal Roar";
            FlavorText = "Let out a terrifying roar that weakens all enemies' defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 4;
            TargetAll = true;
        }
    }
}
