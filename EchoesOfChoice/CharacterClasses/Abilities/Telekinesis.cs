using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Telekinesis : Ability
    {
        public Telekinesis()
        {
            Name = "Telekinesis";
            FlavorText = "An invisible force seizes the enemy and hurls them through the air.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
