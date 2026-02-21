using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Spark : Ability
    {
        public Spark()
        {
            Name = "Spark";
            FlavorText = "A small burst of mischievous flame.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
