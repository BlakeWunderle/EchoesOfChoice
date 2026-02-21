using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class ArcaneBolt : Ability
    {
        public ArcaneBolt()
        {
            Name = "Arcane Bolt";
            FlavorText = "A bolt of pure arcane energy.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 2;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
