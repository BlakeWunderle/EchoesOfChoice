using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class BattleCry : Ability
    {
        public BattleCry()
        {
            Name = "Battle Cry";
            FlavorText = "A thunderous war cry that shakes the enemy.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
