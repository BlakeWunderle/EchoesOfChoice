using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class ShadowAttack : Ability
    {
        public ShadowAttack()
        {
            Name = "Shadow Attack";
            FlavorText = "Leap from the darkness to attack an opponent.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
