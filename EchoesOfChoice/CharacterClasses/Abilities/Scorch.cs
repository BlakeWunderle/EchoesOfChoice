using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Scorch : Ability
    {
        public Scorch()
        {
            Name = "Scorch";
            FlavorText = "Searing flames weaken the enemy's armor.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
